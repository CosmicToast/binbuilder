#!/bin/sh -e

type=c
. ./options.sh
cd "$name"

export CFLAGS='-Os'
export CXXFLAGS='-static -Os'
export LDFLAGS='-all-static -static'

# options!
# - apk deps
if has_opt "apk_add"; then
	# TODO: implement
	# how?
	echo not implemented
fi

# - git submodules
if has_opt "git_submodules"; then
	git submodule update --init
fi

# - libtoolize
if has_opt "libtoolize"; then
	touch install.sh
	libtoolize -cfi
fi

# - autoreconf
if has_opt "autoreconf"; then
	autoreconf -fi
fi

# - autogen.sh
if has_opt "autogen.sh"; then
	./autogen.sh
fi

# - do a plain configure
# TODO: configure opts? how?
if has_opt "configure"; then
	./configure
fi

if [ -z "$mod" ]
then # custom handling
	. "../c/$name.sh"
else # assume plain makefile project
	[ -z "$bin" ] && bin="$mod"
	make "$mod" -j $(nproc)
fi

# scripts may set multiple bin
for f in $bin; do
	strip "$f"
	handlebin "$f"
done
clean
