#!/usr/bin/env bash
set -e

# extra accepted flags:
# * bnames: rename every binary name to this in order
# * versionvar: var to -X the version into
# * commitvar: var to -X the commit into
# * buildvar: var to -X the builddate into
# * buildervar: var to -X the builder info into

# extra accepted options:
# * cgo: enable cgo
# * generate: runs go generate
# * rename: rename every basename of each module to the corresponding binary name in order
# * goldflags: additional go ldflags

# defaults
type=go
goldflags=(-s -w)
. ./options.bash
cd "$pdir"

# goldflags
[ -v versionvar ] && goldflags+=( -X "$versionvar=$VERSION" )
[ -v commitvar ]  && goldflags+=( -X "$commitvar=$COMMIT" )
[ -v buildvar ]   && goldflags+=( -X "$buildvar=$BUILDDATE" )
[ -v buildervar ] && goldflags+=( -X "$buildervar=$BUILDER" )

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
		go build -ldflags="${goldflags[*]}" "$mm"
	else
		make "$mm"
	fi
done
[ -z "$mod" ] && make

# handle renaming
if has_opt rename && let "${#bin[@]} == ${#mod[@]}"; then
	num=$(( ${#bin[@]} - 1 ))
	for ii in $(seq 0 $num); do
		mv $(basename ${mod[$ii]}) ${bin[$ii]}
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

# renames round 2
if let "${#bnames[@]} == ${#bin[@]}"; then
	num=$(( ${#bin[@]} - 1 ))
	for ii in $(seq 0 $num); do
		mv ${bin[$ii]} ${bnames[$ii]}
		bin[$ii]=${bnames[$ii]}
	done
fi

let ${#bin[@]} || declare -n bin=name
for f in "${bin[@]}"; do handlebin "$f"; done
clean
