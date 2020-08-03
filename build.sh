#!/bin/sh -e

# utils
common() {
	script=$1
	image=$2
	shift 2
	docker run -it --rm -v "$PWD":/pwd:Z -w /pwd --entrypoint $script $image "$@"
}
c() {
	common /pwd/c.sh abyssos/abyss:clang "$@"
}
go() {
	common /pwd/go.sh abyssos/abyss:go "$@"
}
rust() {
	common /pwd/rust.sh rust:alpine "$@"
}

for i; do
	case "$i" in
	# bundles
	all)  $0 c go rust ;;
	c)    $0 entr jq mksh samurai ;;
	go)   $0 amfora brpaste caddy chezmoi jump fzf ht mc micro rclone restic scc \
	         serve yggdrasil yggdrasilctl;;
	rust) $0 fd rsign ;;

	# c
	entr)    c -r https://github.com/eradman/entr.git                  ;;
	jq)      c -r https://github.com/stedolan/jq.git                   ;;
	mksh)    c -r https://github.com/MirBSD/mksh.git                   ;;
	samurai) c -r https://github.com/michaelforney/samurai.git -m samu ;;

	# go
	amfora)  go -r https://github.com/makeworld-the-better-one/amfora -m .   ;;
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
	micro) go -r https://github.com/zyedidia/micro.git -m build-all -b micro ;;
	yggdrasil) go -r https://github.com/yggdrasil-network/yggdrasil-go.git -m ./cmd/yggdrasil ;;
	yggdrasilctl) go -r https://github.com/yggdrasil-network/yggdrasil-go.git -m ./cmd/yggdrasilctl ;;

	# rust
	fd)    rust -r https://github.com/sharkdp/fd -b fd ;;
	rsign) rust -r https://github.com/jedisct1/rsign2 -b rsign ;;
	esac
done

# these repos are excluded, reasons attached
# https://github.com/sharkdp/bat             -> no liquid-derive v0.20.0 on musl
# https://github.com/ogham/exa               -> needs limits.sh
# https://github.com/timvisee/ffsend         -> no darling_marro v0.10.2 on musl
# https://github.com/sharkdp/hyperfine       -> no serde_derive v1.0.104 on musl
# https://github.com/meilisearch/MeiliSearch -> no async-attributes v1.1.1 on musl
# https://github.com/BurntSushi/ripgrep.git  -> no serde_derive v1.0.105 on musl
# https://github.com/starship/starship       -> no pest_derive v2.1.0 on musl
# https://github.com/XAMPPRocky/tokei        -> no const-random-macro v0.1.8 on musl
# https://github.com/watchexec/watchexec     -> no darling_macro v0.10.2 on musl
