#!/bin/sh -e

[ "$ENABLE_IPv4" = "1" ] && wget -4qSO /dev/null http://127.0.0.1:8080/adv
[ "$ENABLE_IPv6" = "1" ] && wget -6qSO /dev/null http://[::1]:8080/adv
