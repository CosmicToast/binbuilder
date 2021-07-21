#!/usr/bin/env bash
set -e

# extra accepted flags:
# * @@rfeatures: list of --features to use

# extra accepted options:
# * nocache: do not use sccache
# * nofeat: pass --no-default-features

type=rust
. ./options.bash
cd "$pdir"

# build env
export CARGO_HOME="$cache"/rust
if ! has_opt nocache; then
	export RUSTC_WRAPPER=sccache
	export SCCACHE_DIR="$cache"/sccache
fi

# -sys crates workarounds
export PKG_CONFIG_ALL_STATIC=1
# * libz-sys
export LIBZ_SYS_STATIC=1
# * openssl-sys
export OPENSSL_DIR=/usr
export OPENSSL_NO_VENDOR=1
export OPENSSL_STATIC=1

cargo_opts=(--release --bins)
has_opt nofeat && cargo_opts+=(--no-default-features)

if ! let "${#rfeatures[@]}"; then
	cargo build "${cargo_opts[@]}"
else
	cargo build "${cargo_opts[@]}" --features="${rfeatures[*]}"
fi

if ! let "${#bin[@]}"; then
	bin="$(find target -type f -executable)"
	for bb in "$bin"; do
		strip "$bb"
		handlebin "$bb"
	done
else
	for bb in "${bin[@]}"; do
		p="$(find target -type f -executable -name $bb)"
		strip "$p"
		handlebin "$p"
	done
fi
clean
