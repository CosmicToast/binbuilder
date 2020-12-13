#!/bin/sh
mkdir build
cd build

cmake -DCMARK_SHARED=OFF -DCMAKE_BUILD_TYPE=MinSizerel ..
make

cd -
bin=build/src/cmark
