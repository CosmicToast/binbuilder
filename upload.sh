#!/bin/sh
case "$1" in
	all) "$0" c/ go/ rust/ server/ testing/ ;;
	'') "$0" c/ go/ rust/ testing/ ;;
esac

mc() {
	command mc -q "$@"
}

base=fafnir/bin/$(uname -m)
for pattern; do
	# we know we don't have spaces in the paths
	for f in $(find bin -type f -path "*$pattern*"); do
		# what a mess lmao
		ff=${f#*/}
		oldp=$base/${ff%%-*}-
		new=$base/$ff
		
		oldk=$(mc ls --json $oldp | jq -r .key)
		old=$base/${ff%/*}/$oldk

		mc rm -q $old >/dev/null
		mc cp -q $f $new
	done
done
