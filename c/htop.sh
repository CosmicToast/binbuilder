#!/bin/sh
apk add ncurses-dev
./autogen.sh
./configure
make -j $(nproc)
bin=htop
