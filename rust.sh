#!/bin/sh -e

type=rust
# note: mod is ignored
. ./options.sh
cd "$name"

# build env
export CARGO_HOME="$dir"/cache/rust
if ! has_opt nocache; then
	export RUSTC_WRAPPER=sccache
	export SCCACHE_DIR="$dir"/cache/sccache
fi

# -sys crates workarounds
export PKG_CONFIG_ALL_STATIC=1
# * libz-sys
export LIBZ_SYS_STATIC=1
# * openssl-sys
export OPENSSL_DIR=/usr
export OPENSSL_NO_VENDOR=1
export OPENSSL_STATIC=1

cargo build --release --bins

if [ -z "$bin" ]; then
	bin="$(find -type f -executable)"
	for b in $bin; do
		strip "$b"
		handlebin "$b"
	done
else
	for b in $bin; do
		p="$(find -type f -executable -name $b)"
		strip "$p"
		handlebin "$p"
	done
fi

clean
