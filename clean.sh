#!/bin/sh
[ $# -eq 0 ] && set -- "bin" "manuals" "terminfo"
for i; do
	sudo rm -rf "$i"
done
