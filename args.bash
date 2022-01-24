#!/usr/bin/env bash
# a schemaless argument parser

# this file is licensed under any of the following SPDX licenses
# to be chosen by the user:
# * 0BSD (https://spdx.org/licenses/0BSD.html)
# * BlueOak-1.0.0 (https://blueoakcouncil.org/license/1.0.0)
# * CC0-1.0 (https://creativecommons.org/publicdomain/zero/1.0/)
# * Unlicense (https://unlicense.org/)

# things you can do with it:
# -fval | -f=val | -f val: set "f" to "val"
# --foo=val | --foo val: set "foo" to "val"
# @oval | @o=val | @o val: add "val" to the "o" array
# @@opt=val | @@opt val: add "val" to the "opt" array
# --: stop parsing options, put the rest into $@

# you may have noticed:
# * there are no booleans, long or short. you can emulate them by =yes|no, or have a dedicated options|o array.
# * you cannot reset arrays: you actually can, by using -oval and --opt=val, but you can never make them empty

# something you may not notice without reading the code:
# * values may contain spaces, but may *not* contain literal 's, arg names may not contain spaces, which will break horribly
# * this leaks __die(), __verify(), and $__options. Technically also parse().
# * this is not compatible with numerical args, like -9

# reading notes:
# let NUM is true if num > 0
# this is the same as (( NUM ))

# usage:
# 1. save this to some file (let's say ./args.bash)
# 2. optionally, define default values for any of your arguments
# 3. optionally, define any namerefs to have long/short variants (e.g declare -n r=repo, which will make @r and @@repo the same)
# 4. . ./args.bash "$@"

__die() {
	echo "$@" >&2
	exit
}

# $1 is arg, $2 is val
__verify() {
	[[ ${1% *} != $1 ]] && __die "args may not contain spaces, but `$1` does"
	[[ "${2%\'*}" != $2 ]] && __die "values may not contain 's, but `$2` does"
	true
}

parse() {
	declare val arg
	declare -g __options

	while let $#; do
		arg="$1"
		# needed because we check -v
		unset val; declare val
		shift

		case "$arg" in
		# literal --, stop processing options
		--) __options+=("$@"); return ;;
		# long option
		--*)
			# the arg without the --
			arg=${arg:2}

			# if there's a = in there, we know the value
			if [[ ${arg%%=*} != $arg ]]; then
				val=${arg#*=}
				arg=${arg%%=*}
			fi

			# else, use the next arg
			if [[ ! -v val ]]; then
				let $# || __die "--$arg needs a value, found none"
				val=$1
				shift
			fi

			__verify "$arg" "$val"
			printf -v "$arg" "$val"
		;;
		# short option
		-*)
			# the arg without the -
			arg=${arg:1}

			# we're dealing with -f=val
			if [[ ${arg:1:1} = '=' ]]; then
				val=${arg:2}
				arg=${arg::1}
			fi

			# we haven't found an =, and there's space left - that must be the value
			if [[ ! -v val ]] && (( ${#arg} > 1 )); then
				val=${arg:1}
				arg=${arg::1}
			fi

			# we still haven't found the value, use the next arg
			if [[ ! -v val ]]; then
				let $# || __die "-$arg needs a value, found none"
				val=$1
				shift
			fi

			__verify "$arg" "$val"
			printf -v "$arg" "$val"
		;;
		# long array
		@@*)
			# the arg without the @@
			arg=${arg:2}

			# if there's a = in there, we know the value
			if [[ ${arg%%=*} != $arg ]]; then
				val=${arg#*=}
				arg=${arg%%=*}
			fi

			# else, use the next arg
			if [[ ! -v val ]]; then
				let $# || __die "@@$arg needs a value, found none"
				val=$1
				shift
			fi

			__verify "$arg" "$val"
			eval $arg+="('$val')"
		;;
		# short array
		@*)
			# the arg without the @
			arg=${arg:1}
			
			# we're dealing with @f=val
			if [[ ${arg:1:1} = '=' ]]; then
				val=${arg:2}
				arg=${arg::1}
			fi
			
			# we haven't found an =, and there's space left - that must be the value
			if [[ ! -v val ]] && (( ${#arg} > 1 )); then
				val=${arg:1}
				arg=${arg::1}
			fi
			
			# we still haven't found the value, use the next arg
			if [[ ! -v val ]]; then
				let $# || __die "@$arg needs a value, found none"
				val=$1
				shift
			fi
			
			__verify "$arg" "$val"
			eval $arg+="('$val')"
		;;
		*) __options+=("$arg") ;;
		esac
	done
}

parse "$@"
set -- "${__options[@]}"
