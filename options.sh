#!/bin/sh

# . options.sh inside of other builders - ALL the options should go here

bin=  # override binary name
mod=  # module path, mostly useful for rust
name= # this will be autodetected
repo= # required, for obvious reasons
pack= # set flag to disable
# type should be pre-set in the main script

while getopts b:m:n:r:u name
do
	case $name in
	b) bin="$OPTARG";;
	m) mod="$OPTARG";;
	r) repo="$OPTARG";;
	u) pack=no ;;
	?) exit 2;;
	esac
done

# common deps
. /etc/os-release
case "$ID" in
	alpine) apk --no-cache add git make  ;;
	abyss) ;; # abyss:* is pre-made correctly
	debian) apt update; apt -y --no-install-recommends install git make ;; # slim for aarch64
	# *) echo "Unsupported Distro" && exit 1 ;;
esac

# setup
dir="$PWD"
cache="$dir"/cache/git
name="$(basename $repo .git)"
cacher="$cache"/"$name".git
if [ ! -d "$cacher" ]; then
	mkdir -p "$cache"
	git clone --mirror "$repo" "$cacher"
else
	git -C "$cacher" fetch --all -pP
fi

git clone "$repo" --reference "$cacher" "$name"
ver="$(git -C $name describe --tags --always)"

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
