#!/bin/sh
sudo chown -R toast:toast bin

prefix="$1"
[ -z "$prefix" ] && exit 1

if [ "$prefix" = "all" ]; then
	$0 c
	$0 go
	$0 rust
	exit 0
fi

# clean, only prefix
mcli rm -r --force fafnir/bin/"$prefix"
# upload prefix
mcli cp bin/"$prefix"/* fafnir/bin/"$prefix"/
