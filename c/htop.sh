#!/bin/sh
apk add ncurses-dev autoconf automake
./autogen.sh
./configure
make -j $(nproc)
bin=htop
