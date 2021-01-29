#!/bin/sh
b() {
	docker build -t binbuilder:$1 $1
}

b cbase
for d in c go rust; do b $d; done
