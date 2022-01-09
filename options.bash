#!/usr/bin/env bash
# . options.bash inside of other builders - the common options go here

# package options:
# @@apk: for apk-based builders

# @b|@@bin: binary name
# -m|--mod: module for make/go/similar; used by multiple
# @o|@@opts: options, we have a helper function
# -r|--repo|--src: the source to fetch
# --repotype: the type of repo it is (supported: .git). Populated from --repo if missing.
# -t|--type: type of package, to reset the global per-builder one
# -v|--ver: version; use for fetch systems that don't set their own (like tar) or to override bad ones
# -s|--subver: subversion; see --ver comment

# options.bash recognizes the following opts:
# * u | noupx: do not compress
# builders may define their own, and should use has_opt

# long+short options
declare -n b=bin m=mod n=name o=opts r=repo t=type v=ver s=subver

# aliases
declare -n src=repo

# arg parsing
. ./args.bash

# validation
[[ -x ./upx ]] || o+=('noupx')
[[ -z "$src" ]] && exit 1

# has_opt utility, operates on @o
# you can specify as many args as possible, which will be translated to "any of"
has_opt() {
	for opt in "${o[@]}"; do
		for lookup; do
			[[ $opt = $lookup ]] && return 0
		done
	done
	return 1
}

# common deps
. /etc/os-release
case "$ID" in
esac

# configured deps
if let ${#apk[@]}; then
	apk add "${apk[@]}"
fi

# utilities for cloners
_git() {
	command git "$@"
} >&2

# cloners
cgit() {
	declare -g name subver ver
	declare -l cacher
	: ${name:="$(basename $1 .git)"}
	cacher="$cache"/git/"$name".git
	if [[ ! -d "$cacher" ]]; then
		mkdir -p "$cache"/git
		_git clone --mirror "$1" "$cacher"
	else
		_git -C "$cacher" fetch --all -pP
	fi

	_git clone "$1" --reference "$cacher" "$name"
	: ${ver:="$(git -C $name describe --tags --always)"}
	: ${subver:="$(git rev-parse --verify HEAD)"}
}

ctar() {
	declare -g subver ver
	declare -l cachef
	cachef="$cache"/tar/"$(basename $1)"
	if [[ ! -f "$cachef" ]]; then
		mkdir -p "$cache"/tar
		wget "$1" -O "$cachef"
	fi

	bsdtar -xf "$cachef"
	echo "Using ${ver:?using tarball but no version specified} for $name."
	subver=toast
}

# runs appropriate cloner based on repo name/repotype
cclone() {
	[[ -v repotype ]] || repotype=$1
	case "$repotype" in
	*.git) cgit "$@" ;;
	http*.tar*) ctar "$@" ;;
	*) exit 2 ;; # TODO: error
	esac
}

dir="$PWD"
cache="$dir"/cache
patch="$dir"/patch
cclone "$src"

# the project directory wasn't set
# try to autodetect it
if [[ -z $pdir ]]; then
	for candidate in "$name" "$name-$ver"; do
		if [[ -d "$dir"/"$candidate" ]]; then pdir="$dir"/"$candidate"; break; fi
	done
fi

# in case it was set by hand to something invalid
[[ -d $pdir ]] || pdir=
echo "Detected project directory ${pdir:?could not detect project directory for $src}."

# use mold if applicable
if [[ -x ./ld ]] && has_opt mold; then
	echo "Installing mold..."
	for i in ld ld.gold ld.lld lld \
		ld64.lld ld64.lld.darwinnew ld64.lld.darwinold; do
		[[ -x $(which $i) ]] && cp ./ld $(which $i)
	done
fi

# apply patches
[[ -d "$patch/$name" ]] && for p in "$patch/$name"/*.patch; do
	echo "Applying patch $(basename $p .patch)".
	patch -d "$pdir" -p1 <"$p"
done

export MAKEFLAGS="-j$(nproc) V=1 VERBOSE=1"
export VERSION="$ver"
export COMMIT="$subver"
export BUILDER='https://minio.toast.cafe/bin/index.html'
export BUILDDATE=$(TZ=UTC date +%x)

# util
handlebin() {
	has_opt u noupx || "$dir"/upx "$1"
	cp "$1" "$dir"/bin/"$type"/"$(basename $1)@$ver"
}
clean() {
	rm -r "$pdir"
}

mkdir -p bin/"$type"

# ok now go
echo Finished initializing
