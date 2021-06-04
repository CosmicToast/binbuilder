#!/bin/sh -e

# install libs
apk add pixman-dev wayland-dev wayland-protocols wayland-protocols-dev libxkbcommon-dev fontconfig-dev \
	tllist fcft-dev \
	libffi-dev bzip2-dev expat-dev

CC=clang
CFLAGS="$CFLAGS -DFOOT_IME_ENABLED=1 -DNDEBUG"

LIBS="pixman-1 wayland-protocols wayland-client wayland-cursor xkbcommon fontconfig tllist fcft libffi"
CFLAGS="$CFLAGS -c -I. -std=c17 -D_POSIX_C_SOURCE=200809L -D_GNU_SOURCE=200809L $(pkgconf --static --cflags $LIBS)"
LIBFLAGS="$(pkgconf --static --libs $LIBS)"

SCANNER="$(pkgconf --variable=wayland_scanner wayland-scanner)"
PROTDIR="$(pkgconf --variable=pkgdatadir wayland-protocols)"
PROTS="$(grep wayland_protocols_datadir meson.build | grep -v staging | sed -e s/^[^\']*\'// -e s/\'.*$// -e 1d)"

# generate
./generate-version.sh '(devel)' . version.h
for f in $PROTS; do
	out="$(basename $f .xml)"
	"$SCANNER" client-header "$PROTDIR/$f" "$out.h"
	"$SCANNER" private-code "$PROTDIR/$f" "$out.c"
done

# compile
find . -name '*.c' -exec "$CC" $CFLAGS '{}' -o '{}.o' \;

# link
# WARNING: ORDER IS IMPORTANT
"$CC" $LDFLAGS xsnprintf.c.o client.c.o log.c.o xmalloc.c.o debug.c.o -o footclient
rm client.c.o
"$CC" $LDFLAGS $LIBFLAGS *.o -o foot
