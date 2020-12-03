apk add openssl-dev
touch install.sh # libtoolize is really stupid and will copy to '..' otherwise
libtoolize -cfi
autoreconf -fi
./configure --with-drill
make
bin='drill/drill'
