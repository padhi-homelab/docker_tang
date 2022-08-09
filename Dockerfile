FROM alpine:3.16.2 AS builder


ARG JOSE_COMMIT_SHA=76924deb30647730230f26ac6f2d2c0afe3b6d0c
ARG TANG_COMMIT_SHA=e2059ee1109510a7c14b099af7dcd8631e598270


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
 && ninja install

RUN git clone https://github.com/latchset/tang.git \
 && cd tang \
 && git checkout ${TANG_COMMIT_SHA} \
 && mkdir build \
 && cd build \
 && meson .. --prefix=/usr/local \
 && ninja install




FROM padhihomelab/alpine-base:3.16.1_0.19.0_0.2


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

COPY entrypoint-scripts \
     /etc/docker-entrypoint.d/99-extra-scripts


RUN chmod +x /etc/docker-entrypoint.d/99-extra-scripts/*.sh \
 && apk add --no-cache --update \
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
