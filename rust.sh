#!/bin/sh -e

type=rust
# note: mod is ignored
. ./options.sh
cd "$name"

# build
export CARGO_BUILD_TARGET=$(uname -m)-unknown-linux-musl
export CARGO_HOME="$dir"/cache/rust
export RUSTC_WRAPPER=sccache
export SCCACHE_DIR="$dir"/cache/sccache
cargo build --release --bins

if [ -z "$bin" ]; then
	bin="$(find -type f -executable)"
	for b in $bin; do
		handlebin "$b"
	done
else
	for b in $bin; do
		handlebin "$(find -type f -executable -name $b)"
	done
fi

clean
