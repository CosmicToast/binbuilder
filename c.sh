#!/bin/sh -e

type=c
. ./options.sh
cd "$name"

export CFLAGS='-Os'
export CXXFLAGS='-Os'
export LDFLAGS='-static'
if [ -z "$mod" ]
then # custom handling
	. "../c/$name.sh"
else # assume plain makefile project
	bin="$mod"
	make "$mod"
fi

strip "$bin"
handlebin "$bin"
clean
