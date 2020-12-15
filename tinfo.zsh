#!/bin/zsh -e

# $1 is the url
# $2 is the definitions to compile

dir='terminfo'

pre () {
	echo $(basename $1)
}

bare() {
	pre "$@"
	ht $1 | tic -xo $dir -e $2 -
}

# we're being sourced, this is it
(( $#zsh_eval_context > 1 )) && return

bare https://codeberg.org/dnkl/foot/raw/branch/master/foot.info foot,foot-direct
