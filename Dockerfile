FROM alpine:3.12 AS builder


ARG JOSE_COMMIT_SHA=54bdd6dcce839e6177f732d3d2c07854d988f860
ARG TANG_COMMIT_SHA=711945460398ea7875f74b10da833697679e45ba


RUN apk add --no-cache --update \
    bash \
    g++ gawk git gmp gzip \
    http-parser-dev \
    isl-dev \
    jansson-dev \
    meson mpc1-dev mpfr-dev musl-dev \
    ninja \
    openssl-dev \
    tar \
    zlib-dev

RUN git clone https://github.com/latchset/jose.git \
 && cd jose \
 && git checkout ${JOSE_COMMIT_SHA} \
 && mkdir build \
 && cd build \
 && meson .. --prefix=/usr/local \
 && ninja install \
 && mkdir /patches

RUN git clone https://github.com/latchset/tang.git \
 && cd tang \
 && git checkout ${TANG_COMMIT_SHA} \
 && mkdir build \
 && cd build \
 && meson .. --prefix=/usr/local \
 && ninja install




FROM padhihomelab/alpine-base:312.019.0201


COPY --from=builder \
     /usr/local/bin/jose \
     /usr/local/bin/jose
COPY --from=builder \
     /usr/local/lib/libjose.so.0  \
     /usr/local/lib/libjose.so.0
COPY --from=builder \
     /usr/local/lib/libjose.so.0.0.0 \
     /usr/local/lib/libjose.so.0.0.0

COPY --from=builder \
     /usr/local/libexec/tangd \
     /usr/local/bin/tangd
COPY --from=builder \
     /usr/local/libexec/tangd-keygen \
     /usr/local/bin/tangd-keygen

COPY setup-volume.sh \
     /etc/docker-entrypoint.d/setup-volume.sh


RUN chmod +x /etc/docker-entrypoint.d/setup-volume.sh \
 && apk add --no-cache --update \
        bash \
        http-parser \
        jansson \
        openssl \
        socat \
        zlib


EXPOSE 8080
VOLUME [ "/db" ]


CMD [ "socat", "tcp-l:8080,reuseaddr,fork", "exec:'tangd /db'" ]


HEALTHCHECK --start-period=5s --interval=30s --timeout=5s --retries=3 \
        CMD ["wget", "--tries", "5", "-qSO", "/dev/null",  "http://localhost:8080/adv"]
