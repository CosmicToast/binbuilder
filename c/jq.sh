#!/bin/sh
git submodule update --init
autoreconf -fi
./configure --with-oniguruma=builtin --disable-maintainer-mode
make
bin=jq
