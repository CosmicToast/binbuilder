#!/bin/sh
apk add ncurses-dev cmd:autoreconf cmd:aclocal
./autogen.sh
./configure
make -j $(nproc)
bin=htop
