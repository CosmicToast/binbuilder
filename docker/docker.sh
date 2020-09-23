#!/bin/sh
for d in *; do
	docker build -t binbuilder:$d $d
done
