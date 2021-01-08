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
	c)    $0 cmark entr foot htop iproute2 jq mksh rc samurai scdoc ;;
	go)   $0 amfora chezmoi jump fzf ht mc micro rclone restic scc \
	         serve ;;
	rust) $0 bat exa fd rg rsign sk ;;

	# c
	cmark) cc -r https://github.com/commonmark/cmark.git ;;
	entr)     cc -r https://github.com/eradman/entr.git                  ;;
	foot)     cc -r https://codeberg.org/dnkl/foot.git -u                ;;
	htop)     cc -r https://github.com/htop-dev/htop.git                 ;;
	iproute2) cc -r git://git.kernel.org/pub/scm/network/iproute2/iproute2.git ;;
	jq)       cc -r https://github.com/stedolan/jq.git                   ;;
	mksh)     cc -r https://github.com/MirBSD/mksh.git -u                ;;
	rc)       cc -r https://github.com/muennich/rc -u                    ;;
	samurai)  cc -r https://github.com/michaelforney/samurai.git -m samu ;;
	scdoc)    cc -r https://git.sr.ht/~sircmpwn/scdoc -m scdoc           ;;

	# go
	chezmoi) go -r https://github.com/twpayne/chezmoi.git   -m .            ;;
	fzf)     go -r https://github.com/junegunn/fzf.git      -m .            ;;
	ht)      go -r https://github.com/nojima/httpie-go.git  -m ./cmd/ht     ;;
	jump)    go -r https://github.com/gsamokovarov/jump.git -m .            ;;
	mc)      go -r https://github.com/minio/mc.git          -m .            ;;
	rclone)  go -r https://github.com/rclone/rclone.git     -m .            ;;
	restic)  go -r https://github.com/restic/restic.git     -m ./cmd/restic ;;
	scc)	 go -r https://github.com/boyter/scc.git        -m .            ;;
	serve)   go -r https://github.com/syntaqx/serve.git     -m ./cmd/serve  ;;
	# these are long, ok?
	amfora) go -r https://github.com/makeworld-the-better-one/amfora -m amfora ;;
	micro) go -r https://github.com/zyedidia/micro.git -m build-all -b micro ;;

	# rust
	bat)   rust -r https://github.com/sharkdp/bat.git        -b bat   ;;
	exa)   rust -r https://github.com/ogham/exa.git          -b exa   ;;
	fd)    rust -r https://github.com/sharkdp/fd.git         -b fd    ;;
	rg)    rust -r https://github.com/BurntSushi/ripgrep.git -b rg    ;;
	rsign) rust -r https://github.com/jedisct1/rsign2.git    -b rsign ;;
	sk)    rust -r https://github.com/lotabout/skim.git      -b sk    ;;

	# manual
	# packages that aren't bult in "all" builds
	# this means it's either not worth distributing them regularly
	# or they're "testing" packages
	#   - testing
	drill) cc -t testing -r https://github.com/NLnetLabs/ldns.git -o link ;;
	duf) go -t testing -r https://github.com/muesli/duf.git -m . ;;
	elvish) go -t testing -r https://github.com/elves/elvish.git -m . -u ;; # I would love to -o generate, but they don't use the go-run method
	gomplate) go -t testing -r https://github.com/hairyhenderson/gomplate.git -m ./cmd/gomplate ;;
	gotop) go -t testing -r https://github.com/xxxserxxx/gotop.git -m ./cmd/gotop ;;
	handlr) rust -t testing -r https://github.com/chmln/handlr.git -b handlr ;;
	hyperfine) rust -t testing -r https://github.com/sharkdp/hyperfine.git -b hyperfine ;;
	lua) cc -t testing -r https://github.com/lua/lua.git -o link -u ;;
	nmap) cc -t testing -r https://github.com/nmap/nmap.git -o link ;;
	rsync) cc -t testing -r https://github.com/WayneD/rsync.git ;;
	sd) rust -t testing -r https://github.com/chmln/sd.git -b sd ;;
	sixel) cc -t testing -r https://github.com/saitoha/libsixel.git ;;
	toybox) cc -t testing -r https://github.com/landley/toybox.git -u ;;
	watchexec) rust -t testing -r https://github.com/watchexec/watchexec.git -b watchexec ;;
	#   - servers / occasional
	caddy) go -t server -r https://github.com/caddyserver/caddy.git -m ./cmd/caddy ;;
	dnsmasq) cc -t server -r git://thekelleys.org.uk/dnsmasq.git ;;
	echoip) go -t server -r https://github.com/mpolden/echoip.git -m ./cmd/echoip ;;
	meilisearch)  rust -t server -r https://github.com/meilisearch/MeiliSearch.git -b meilisearch ;;
	minio) go -t server -r https://github.com/minio/minio.git -m . ;;
	unbound) cc -t server -r https://github.com/NLnetLabs/unbound.git ;;
	yggdrasil) go -t server -r https://github.com/yggdrasil-network/yggdrasil-go.git -m './cmd/yggdrasil ./cmd/yggdrasilctl' ;;
	esac
done

# these repos are excluded, reasons attached
# https://github.com/timvisee/ffsend   -> openssl-sys
# https://github.com/starship/starship -> openssl-sys
