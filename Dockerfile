FROM alpine:3.12 AS builder


ARG JOSE_COMMIT_SHA=54bdd6dcce839e6177f732d3d2c07854d988f860
ARG TANG_COMMIT_SHA=2ef4acf9d4f2113c6b1789b64a7357af667a3efe


RUN apk add --no-cache \
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
COPY --from=builder \
     /usr/local/libexec/tangd-update \
     /usr/local/bin/tangd-update

COPY init-tangd.sh \
     /usr/local/bin/init-tangd


RUN chmod +x /usr/local/bin/init-tangd \
 && apk add --no-cache \
        bash \
        http-parser \
        jansson \
        openssl \
        socat \
        wget \
        zlib


EXPOSE 8080
VOLUME [ "/home/user/db" ]


CMD [ "init-tangd" ]


HEALTHCHECK --start-period=1m --interval=120s --timeout=5s --retries=3 \
        CMD ["wget", "--tries", "5", "-qSO", "/dev/null",  "http://localhost:8080/adv"]
