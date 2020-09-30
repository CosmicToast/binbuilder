#!/bin/sh -e

# default runner
[ -z "$RUNNER" ] && RUNNER=docker

# utils
common() {
	# disable upx if it's missing
	[ -f "$PWD/upx" ] || set -- "$@" -u
	# allow picking between docker and local runners
	case "$RUNNER" in
	docker) container docker "$@" ;;
	podman) container podman "$@" ;;
	shell) shell "$@" ;;
	esac
}

container() {
	cmd=$1
	script=$2
	image=$3
	shift 3
	$cmd run -it --rm -v "$PWD":/pwd:Z -w /pwd --entrypoint /pwd/"$script" $image "$@"
}
shell() {
	script=$1
	shift 2 # image not relevant
	./"$script" "$@"
}

cc() {
	common c.sh binbuilder:c "$@"
}
go() {
	common go.sh binbuilder:go "$@"
}
rust() {
	common rust.sh binbuilder:rust "$@"
}

for i; do
	case "$i" in
	# bundles
	all)  $0 c go rust ;;
	c)    $0 entr foot htop jq mksh samurai scdoc ;;
	go)   $0 amfora caddy chezmoi jump fzf ht mc micro rclone restic scc \
	         serve yggdrasil yggdrasilctl;;
	rust) $0 bat exa fd rg rsign ;;

	# c
	entr)    cc -r https://github.com/eradman/entr.git                  ;;
	foot)    cc -r https://codeberg.org/dnkl/foot.git -u                ;;
	htop)    cc -r https://github.com/htop-dev/htop.git                 ;;
	jq)      cc -r https://github.com/stedolan/jq.git                   ;;
	mksh)    cc -r https://github.com/MirBSD/mksh.git -u                ;;
	samurai) cc -r https://github.com/michaelforney/samurai.git -m samu ;;
	scdoc)   cc -r https://git.sr.ht/~sircmpwn/scdoc -m scdoc           ;;

	# go
	caddy)   go -r https://github.com/caddyserver/caddy.git  -m ./cmd/caddy  ;;
	chezmoi) go -r https://github.com/twpayne/chezmoi.git    -m .            ;;
	fzf)     go -r https://github.com/junegunn/fzf.git       -m .            ;;
	ht)      go -r https://github.com/nojima/httpie-go.git   -m ./cmd/ht     ;;
	jump)    go -r https://github.com/gsamokovarov/jump.git  -m .            ;;
	mc)      go -r https://github.com/minio/mc.git           -m .            ;;
	rclone)  go -r https://github.com/rclone/rclone.git      -m .            ;;
	restic)  go -r https://github.com/restic/restic.git      -m ./cmd/restic ;;
	scc)	 go -r https://github.com/boyter/scc.git         -m .            ;;
	serve)   go -r https://github.com/syntaqx/serve.git      -m ./cmd/serve  ;;
	# these are long, ok?
	amfora) go -r https://github.com/makeworld-the-better-one/amfora -m amfora ;;
	micro) go -r https://github.com/zyedidia/micro.git -m build-all -b micro ;;
	yggdrasil) go -r https://github.com/yggdrasil-network/yggdrasil-go.git -m ./cmd/yggdrasil ;;
	yggdrasilctl) go -r https://github.com/yggdrasil-network/yggdrasil-go.git -m ./cmd/yggdrasilctl ;;

	# rust
	bat)   rust -r https://github.com/sharkdp/bat.git        -b bat   ;;
	exa)   rust -r https://github.com/ogham/exa.git          -b exa   ;;
	fd)    rust -r https://github.com/sharkdp/fd.git         -b fd    ;;
	rg)    rust -r https://github.com/BurntSushi/ripgrep.git -b rg    ;;
	rsign) rust -r https://github.com/jedisct1/rsign2.git    -b rsign ;;

	# manual
	# packages that aren't bult in "all" builds
	# this means it's either not worth distributing them regularly
	# or they're "testing" packages
	duf) go -r https://github.com/muesli/duf.git -m .
	esac
done

# these repos are excluded, reasons attached
# https://github.com/timvisee/ffsend         -> no darling_marro v0.10.2 on musl
# https://github.com/chmln/handlr            -> no clap_derive v3.0.0-beta.1 on musl
# https://github.com/sharkdp/hyperfine       -> no serde_derive v1.0.104 on musl
# https://github.com/meilisearch/MeiliSearch -> no async-attributes v1.1.1 on musl
# https://github.com/starship/starship       -> no pest_derive v2.1.0 on musl
# https://github.com/XAMPPRocky/tokei        -> no const-random-macro v0.1.8 on musl
# https://github.com/watchexec/watchexec     -> no darling_macro v0.10.2 on musl
