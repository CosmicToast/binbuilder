#!/bin/sh
[ $# -eq 0 ] && set -- "bin" "manuals"
for i; do
	sudo rm -rf "$i"
done
