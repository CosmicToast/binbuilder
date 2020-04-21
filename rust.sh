#!/bin/sh -e

type=rust
# note: mod is ignored
. ./options.sh
cd "$name"

# build
export CARGO_HOME=/pwd/cache/rust
export RUSTFLAGS='-C target-feature=+crt-static'
if [ -z "$bin" ]
then # build everything
	cargo build --release --bins
else # build specific bin
	cargo build --release --bin "$bin"
fi

# compress and deploy
if [ -z "$bin" ]
then # loop over all bins to detect
	for f in ./target/release/*; do
		[ -f "$f" ] && [ -x "$f" ] || continue
		handlebin "$f"
	done
else # just do it for the one bin
	handlebin ./target/release/"$bin"
fi
clean