#!/bin/sh
# this will install everything under ./bin into ~/bin, as if you uploaded it all and used dl.sh
# if you call it with arguments, it will use the specific files
# this will fail horribly if there are no files, so good luck lol

[ $# -eq 0 ] && find bin -type f -exec ./$0 {} +

mkdir -p ~/bin
for i
do
	f="${i##*/}"
	f="${f%%@*}"
	echo "installing $i to ~/bin/$f"
	cp "$i" ~/bin/"$f"
done
