#!/bin/sh
[ $# -eq 0 ] && set -- "bin"
for i; do
	sudo chown -R toast:toast "$1"
	rm -rf "$1"
done