#!/bin/sh

# list all of the known build.sh packages
# 1. get only the lines with a "-r" in them, since "-r" is the one required argument
# 2. further, specify only the ones that have a ")" in them (since all of them are in a switch-case)
# 3. then, remove any lines starting with a "#" (comment), we can't remove based on containing a comment, since some lines have postfix comments
# 4. then run sed to extract the names (remove whitespace from start, then remove the first ")" and everything that follows)

grep build.sh -e '-r' |
	grep ')' |
	grep -v '^#' |
	sed -Es 's/^\s+//;s/\).*//'
