#!/bin/sh
git submodule update --init
apk add autoconf automake libtool
autoreconf -fi
./configure --with-oniguruma=builtin --disable-maintainer-mode
make -j $(nproc)
bin=jq
