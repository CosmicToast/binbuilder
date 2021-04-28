#!/usr/bin/env bash
set -e

# extra accepted flags:

# extra accepted options:
# * cgo: enable cgo
# * generate: runs go generate

# defaults
type=go
. ./options.bash
cd "$name"

# build
if ! has_opt cgo; then
	export CGO_ENABLED=0
fi
export GOPATH="$cache"/go

# generate step
if has_opt generate; then
	go generate ./...
fi

for mm in "${mod[@]}"; do
	if [[ -d $mm ]]; then
		go build -ldflags='-s -w' "$mm"
	else
		make "$mm"
	fi
done
[ -z "$mod" ] && make

# wesmart
if ! let ${#bin[@]} && let ${#mod[@]}; then
	for mm in "${mod[@]}"; do
		bm=$(basename "$mm")
		[[ $bm = '.' ]] && bm="$name"
		bin+=("$bm")
	done
fi
let ${#bin[@]} || declare -n bin=name
for f in "${bin[@]}"; do handlebin "$f"; done
clean
