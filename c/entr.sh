#!/bin/sh
./configure
bin=entr
make $bin -j $(nproc)
