lv=5.4
bin=bozohttpd

apk add lua$lv-dev

CFLAGS="$CFLAGS -I/usr/include/lua$lv -DNO_BLOCKLIST_SUPPORT -DNO_SSL_SUPPORT
-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -D_DEFAULT_SOURCE"
LIBS="/usr/lib/lua$lv/liblua.a"

clang $CFLAGS $LDFLAGS $LIBS *.c -o $bin
