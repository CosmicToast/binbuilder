apk add acl-dev lz4-dev openssl-dev zlib-dev zstd-dev

# do not trust the bundled configure script
autoreconf -fi
autoconf -o configure.sh
autoheader && touch config.h.in

# TODO: add xhash to abyss?
./configure --disable-xxhash --disable-md2man
make
bin=rsync
