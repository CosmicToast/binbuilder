#!/usr/bin/env bash
set -e

# extra accepted flags:
# @@cmake: cmake options, will run cmake if set
# @@configure: configure options, will run configure if set

# extra accepted options:
# * dumb_curses: something tries to link to curses but doesn't do detection, make symlinks
# * git_submodules: clone submodules too, but only when we're git
# * libtoolize: run libtoolize (you usually want autoreconf, this is for special cases)
# * autoreconf: run autoreconf (compare to autogen.sh?)
# * autogen.sh: run autogen.sh
# * configure: run configure with no args (@@configure is empty)
# * cmake: run cmake with no args (@@cmake is empty)
# * mimalloc: add "-lc++ /lib/mimalloc.o" to LDFLAGS - verify this works before you use it!

# defaults
type=c
. ./options.bash
cd "$name"

export CFLAGS='-Os'
export CXXFLAGS='-static -Os'
export LDFLAGS='-all-static -static'

# declarative extensions!

# - curses symlinks
if has_opt dumb_curses; then
	for i in curses ncurses; do
		ln -s libncursesw.a /usr/lib/lib$i.a
	done
fi

# - git submodules
if has_opt git_submodules && [[ -d .git ]]; then
	git submodule update --init
fi

# - libtoolize
if has_opt libtoolize; then
	libtoolize -cfi
fi

# - autoreconf
if has_opt autoreconf; then
	autoreconf -fi
fi

# - autogen.sh
if has_opt autogen.sh; then
	./autogen.sh
fi

if let ${#configure[@]} || has_opt configure; then
	./configure "${configure[@]}"
fi

if let ${#cmake[@]} || has_opt cmake; then
	cmake "${cmake[@]}"
fi

if has_opt mimalloc; then
	export LDFLAGS="$LDFLAGS -lc++ /lib/mimalloc.o"
fi

if [ -z "$mod" ]
then # custom handling
	. "../c/$name.sh"
else # assume plain makefile project
	let ${#bin[@]} || declare -n bin=mod
	echo "${mod[@]}"
	for mm in "${mod[@]}"; do make "$mm"; done
fi

# scripts may set multiple bins
for f in "${bin[@]}"; do
	strip "$f"
	handlebin "$f"
done
clean
