#!/usr/bin/env bash
set -e

# extra accepted flags:

# extra accepted options:
# * cgo: enable cgo
# * generate: runs go generate
# * rename: rename every basename of each module to the corresponding binary name in order

# defaults
type=go
. ./options.bash
cd "$pdir"

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

# handle renaming
if has_opt rename && let "${#bin[@]} == ${#mod[@]}"; then
	num=$(( ${#bin[@]} - 1 ))
	for ii in $(seq 0 $num); do
		mv $(basename ${mod[$ii]}) ${bin[@]}
	done
fi

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
