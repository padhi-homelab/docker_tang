#!/bin/sh -e

if [ "$ENABLE_IPv4" = "1" ]; then
  wget -4qSO /dev/null http://127.0.0.1:8080/adv
fi

if [ "$ENABLE_IPv6" = "1" ]; then
  wget -6qSO /dev/null http://[::1]:8080/adv
fi
