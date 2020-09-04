#!/bin/sh -e

type=go
. ./options.sh
cd "$name"

# build
export CGO_ENABLED=0
export GOPATH="$dir"/cache/go
if [ -d "$mod" ]
then # it's a real go module
	go build -ldflags='-s -w' "$mod"
else # it's a makefile target, $mod may be empty
	make $mod -j $(nproc)
fi

# wesmart
[ -z "$bin" ] && [ ! -z "$mod" ] && bin="$(basename $mod)"
[ -z "$bin" ] || [ "$bin" = '.' ] && bin="$name" 
handlebin "$bin"
clean
