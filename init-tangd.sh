#!/bin/bash -e

cd "/data"

mkdir -p db cache
grep -r -q '"sign"' db || tangd-keygen db
tangd-update db cache

socat tcp-l:8080,reuseaddr,fork exec:"tangd cache"
