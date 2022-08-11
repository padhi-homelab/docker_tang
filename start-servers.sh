#!/bin/sh -e

TANG="system:'REMOTE_ADDR=\$SOCAT_PEERADDR tangd /db'"

if [ "$ENABLE_IPv4" = "1" ]; then
  socat TCP4-LISTEN:8080,reuseaddr,fork "$TANG" &
fi

if [ "$ENABLE_IPv6" = "1" ]; then
  socat TCP6-LISTEN:8080,ipv6only=1,reuseaddr,fork "$TANG" &
fi

wait
