#!/bin/sh

# . options.sh inside of other builders - ALL the options should go here

bin=  # override binary name
mod=  # module path, mostly useful for rust
name= # this will be autodetected
repo= # required, for obvious reasons
pack= # set flag to disable
# type should be pre-set in the main script, but can be overriden

while getopts b:m:n:r:t:u name
do
	case $name in
	b) bin="$OPTARG";;
	m) mod="$OPTARG";;
	r) repo="$OPTARG";;
	t) type="$OPTARG";;
	u) pack=no ;;
	?) exit 2;;
	esac
done

# common deps
. /etc/os-release
case "$ID" in
esac

# setup
cclone() {
	git() {
		command git "$@"
	} >&2

	# $1 is repo
	name="$(basename $repo .git)"
	cacher="$cache"/"$name".git
	if [ ! -d "$cacher" ]; then
		mkdir -p "$cache"
		git clone --mirror "$1" "$cacher"
	else
		git -C "$cacher" fetch --all -pP
	fi

	git clone "$1" --reference "$cacher" "$name"
	echo "$name"
}

dir="$PWD"
cache="$dir"/cache/git
name="$(cclone $repo)"
ver="$(git -C $name describe --tags --always)"

export MAKEOPTS="-j$(nproc)"
export VERSION="$ver"
export COMMIT="$(git rev-parse --verify HEAD)"
export BUILDER='https://minio.toast.cafe/bin/index.html'

# util
handlebin() {
	[ "$pack" != "no" ] && "$dir"/upx "$1"
	cp "$1" "$dir"/bin/"$type"/"$(basename $1)-$ver"
}
clean() {
	rm -r "$dir"/"$name"
}

mkdir -p bin/"$type"

# ok now go
echo Finished initializing
