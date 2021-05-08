#!/bin/sh
mkdir build
cd build

cmake -DCMARK_SHARED=OFF -DCMAKE_BUILD_TYPE=MinSizeRel ..
make

cd -
bin=build/src/cmark
