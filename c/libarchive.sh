apk add xz-dev bzip2-dev zlib-dev libb2-dev lz4-dev zstd-dev xz-dev lzo-dev nettle-dev libxml2-dev expat-dev
./configure --enable-bsdtar=static --disable-bsdcat --disable-bsdcpio
make
bin=bsdtar
