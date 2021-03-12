#!/bin/sh
./configure --with-curses --disable-nls --enable-readline --without-bash-malloc --with-installed-readline --enable-static-link
make
bin=bash
