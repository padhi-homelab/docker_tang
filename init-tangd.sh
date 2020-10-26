#!/bin/bash -e

cd "${1:-/home/user}"

mkdir -p db/tang cache/tang
grep -r -q '"sign"' db/tang || tangd-keygen db/tang
tangd-update db/tang cache/tang

socat tcp-l:8080,reuseaddr,fork exec:"tangd cache/tang"
