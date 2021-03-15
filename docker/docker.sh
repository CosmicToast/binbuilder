#!/bin/sh
: ${DOCKER:=podman}

b() {
	$DOCKER build -t binbuilder:$1 $1
}

b base
b cbase
for d in c go rust; do b $d; done
