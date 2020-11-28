#!/bin/sh -e

type=go
. ./options.sh
cd "$name"

# build
export CGO_ENABLED=0
export GOPATH="$dir"/cache/go

# generate step
if has_opt generate; then
	go generate ./...
fi

for m in $mod; do
	if [ -d $m ]; then
		go build -ldflags='-s -w' $m
	else
		make $m
	fi
done
[ -z "$mod" ] && make

# wesmart
if [ -z "$bin" ] && [ ! -z "$mod" ]; then
	for m in $mod; do
		mm="$(basename $m)"
		[ $mm = '.' ] && mm="$name"
		bin="$bin $mm"
	done
fi
[ -z "$bin" ] && bin="$name"
for f in $bin; do handlebin "$f"; done
clean
