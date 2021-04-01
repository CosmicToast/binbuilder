#!/usr/bin/env bash
# . options.bash inside of other builders - the common options go here

# package options:
# @@apk: for apk-based builders

# @b|@@bin: binary name
# -u|+u: enable/disable upx; on by default, unless there is no upx in .
# -m|--mod: module for make/go/similar; used by multiple
# @o|@@opts: options, we have a helper function
# -r|--repo|--src: the source to fetch
# --repotype: the type of repo it is (supported: .git). Populated from --repo if missing.
# -t|--type: type of package, to reset the global per-builder one
# -v|--ver: version; will not override, use for fetch systems that don't set their own (like tar)
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
	name="$(basename $1 .git)"
	cacher="$cache"/git/"$name".git
	if [[ ! -d "$cacher" ]]; then
		mkdir -p "$cache"
		_git clone --mirror "$1" "$cacher"
	else
		_git -C "$cacher" fetch --all -pP
	fi

	_git clone "$1" --reference "$cacher" "$name"
	ver="$(git -C $name describe --tags --always)"
	subver="$(git rev-parse --verify HEAD)"
}

# runs appropriate cloner based on repo name/repotype
cclone() {
	[[ -v repotype ]] || repotype=$1
	case "$repotype" in
	*.git) cgit "$@" ;;
	*) exit 2 ;; # TODO: error
	esac
}

dir="$PWD"
cache="$dir"/cache
cclone "$src"

export MAKEFLAGS="-j$(nproc)"
export VERSION="$ver"
export COMMIT="$subver"
export BUILDER='https://minio.toast.cafe/bin/index.html'

# util
handlebin() {
	has_opt u noupx || "$dir"/upx "$1"
	cp "$1" "$dir"/bin/"$type"/"$(basename $1)@$ver"
}
clean() {
	rm -r "$dir"/"$name"
}

mkdir -p bin/"$type"

# ok now go
echo Finished initializing
