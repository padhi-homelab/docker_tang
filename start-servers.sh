#!/bin/sh -e

TANG="system:'REMOTE_ADDR=\$SOCAT_PEERADDR tangd /db'"

[ "$ENABLE_IPv4" = "1" ] && socat TCP4-LISTEN:8080,reuseaddr,fork "$TANG" &
[ "$ENABLE_IPv6" = "1" ] && socat TCP6-LISTEN:8080,ipv6only=1,reuseaddr,fork "$TANG" &

wait
