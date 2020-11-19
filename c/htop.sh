#!/bin/sh
apk add ncurses-dev
./autogen.sh
./configure
make
bin=htop
