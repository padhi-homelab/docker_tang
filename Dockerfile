FROM alpine:3.19.1 AS builder


ARG JOSE_COMMIT_SHA=76ec70ba4875a6ab6ad83b295e3da94685bbacb8
ARG TANG_COMMIT_SHA=02105756ee2a3afbd7065a47664d202788c9b584


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




FROM padhihomelab/alpine-base:3.19.1_0.19.0_0.2


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
COPY check-servers.sh \
     /usr/local/bin/check-servers
COPY start-servers.sh \
     /usr/local/bin/start-servers


RUN chmod +x /etc/docker-entrypoint.d/99-extra-scripts/*.sh \
             /usr/local/bin/check-servers \
             /usr/local/bin/start-servers \
 && apk add --no-cache --update \
            http-parser \
            jansson \
            openssl \
            socat \
            wget \
            zlib


EXPOSE 8080
VOLUME [ "/db" ]


ENV ENABLE_IPv4=1
ENV ENABLE_IPv6=0

CMD "start-servers"


HEALTHCHECK --start-period=5s --timeout=3s \
        CMD "check-servers"
