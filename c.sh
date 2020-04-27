#!/bin/sh -e

type=c
. ./options.sh
cd "$name"

export CFLAGS='-Os'
export CXXFLAGS='-static -Os'
export LDFLAGS='-all-static -static'
if [ -z "$mod" ]
then # custom handling
	. "../c/$name.sh"
else # assume plain makefile project
	[ -z "$bin" ] && bin="$mod"
	make "$mod"
fi

strip "$bin"
handlebin "$bin"
clean
