apk add openssl-dev
ln -s $(which llvm-ar) /bin/ar
touch install.sh # libtoolize is really stupid and will copy to '..' otherwise
libtoolize -cfi
autoreconf -fi
./configure --with-drill
make
bin='drill/drill'
