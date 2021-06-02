#!/bin/sh -e

# default runner
[ -z "$RUNNER" ] && RUNNER=podman

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
	common c.bash binbuilder:c "$@"
}
go() {
	common go.bash binbuilder:go "$@"
}
rust() {
	common rust.bash binbuilder:rust "$@"
}

for i; do
	case "$i" in
	# convenience shortcut
	# lets you do something like:
	# ./build.sh run cc -r git.server/my/repo.git
	# for testing purposes
	run) shift; "$@"; exit 0;;
	
	# bundles
	all)  $0 c go rust ;;
	c)    $0 cmark entr foot htop iproute2 jq mksh rc samurai scdoc ;;
	go)   $0 amfora chezmoi jump fzf ht mc micro rclone restic scc \
	         serve ;;
	rust) $0 bat exa fd rg rsign sk ;;

	# c
	cmark)    cc -r https://github.com/commonmark/cmark.git @o mimalloc ;;
	entr)     cc -r https://github.com/eradman/entr.git @o configure @m entr @o mimalloc ;;
	foot)     cc -r https://codeberg.org/dnkl/foot.git @o u @b foot @b footclient @o mimalloc ;; # TODO: xkbcommon
	htop)     cc -r https://github.com/htop-dev/htop.git @o autogen.sh @o configure @m all @b htop @o mimalloc ;;
	iproute2) cc -r git://git.kernel.org/pub/scm/network/iproute2/iproute2.git @b ip/ip @b misc/ss ;;
	jq) cc -r https://github.com/stedolan/jq.git @o git_submodules @o autoreconf @o mimalloc \
		@@configure --with-onigurama=builtin @@configure --disable-maintainer-mode @m all @b jq ;;
	mksh)     cc -r https://github.com/MirBSD/mksh.git @o u @o mimalloc              ;;
	rc)       cc -r https://github.com/muennich/rc.git @o u @b rc @o mimalloc        ;;
	samurai)  cc -r https://github.com/michaelforney/samurai.git @m samu @o mimalloc ;;
	scdoc)    cc -r https://git.sr.ht/~sircmpwn/scdoc @m scdoc --repotype=.git @o mimalloc ;;

	# go
	chezmoi) go -r https://github.com/twpayne/chezmoi.git   @m .            ;;
	fzf)     go -r https://github.com/junegunn/fzf.git      @m .            ;;
	ht)      go -r https://github.com/nojima/httpie-go.git  @m ./cmd/ht     ;;
	jump)    go -r https://github.com/gsamokovarov/jump.git @m .            ;;
	mc)      go -r https://github.com/minio/mc.git          @m .            ;;
	rclone)  go -r https://github.com/rclone/rclone.git     @m .            ;;
	restic)  go -r https://github.com/restic/restic.git     @m ./cmd/restic ;;
	scc)	 go -r https://github.com/boyter/scc.git        @m .            ;;
	serve)   go -r https://github.com/syntaqx/serve.git     @m ./cmd/serve  ;;
	# these are long, ok?
	amfora) go -r https://github.com/makeworld-the-better-one/amfora.git @m amfora ;;
	micro) go -r https://github.com/zyedidia/micro.git @m build-all @b micro ;;

	# rust
	bat)   rust -r https://github.com/sharkdp/bat.git        @b bat   ;;
	exa)   rust -r https://github.com/ogham/exa.git          @b exa   ;;
	fd)    rust -r https://github.com/sharkdp/fd.git         @b fd    ;;
	rg)    rust -r https://github.com/BurntSushi/ripgrep.git @b rg    ;;
	rsign) rust -r https://github.com/jedisct1/rsign2.git    @b rsign ;;
	sk)    rust -r https://github.com/lotabout/skim.git      @b sk    ;;

	# manual
	# not automatically built ("all") repositories
	# games: games! unfortunately most games aren't packageable like this, but some are!
	# server: packages of servers, or servers + utilities (e.g dropbear)
	# testing: packages that are either not stabilized, or are purposefully excluded from "all"

	# Games
	advent) cc -t games -r https://github.com/troglobit/advent4.git @o autogen.sh @o configure -m all -b src/advent ;;
	ninvaders) cc -t games -r https://github.com/sf-refugees/ninvaders.git -b ninvaders @o mimalloc ;;
	nsnake) cc -t games -r https://github.com/alexdantas/nSnake.git -b bin/nsnake @o mimalloc ;;
	nudoku) cc -t games -r https://github.com/jubalh/nudoku.git @@apk gettext-tiny-dev @o autoreconf @@configure --disable-nls -m all -b src/nudoku @o mimalloc ;;

	# Testing
	age) go -t testing -r https://github.com/FiloSottile/age.git @m ./cmd/age @m ./cmd/age-keygen ;;
	bash) cc -t testing -r https://git.savannah.gnu.org/git/bash.git @o u @o dumb_curses \
			 @@configure --with-curses @@configure --disable-nls @@configure --enable-readline \
			 @@configure --without-bash-malloc @@configure --with-installed-readline \
			 @@configure --enable-static-link @m all @b bash @o mimalloc ;;
	drill) cc -t testing -r https://github.com/NLnetLabs/ldns.git @o autoreconf \
			  @o libtoolize @@configure --with-drill @m all @b drill/drill @o mimalloc ;;
	duf) go -t testing -r https://github.com/muesli/duf.git @m . ;;
	elvish) go -t testing -r https://github.com/elves/elvish.git @m ./cmd/elvish @o u ;; # I would love to -o generate, but they don't use the go-run method
	fdupes) cc -t testing -r https://github.com/adrianlopezroche/fdupes.git @o autoreconf @o configure @m fdupes @o mimalloc ;;
	ffsend) rust -t testing -r https://github.com/timvisee/ffsend.git @b ffsend ;;
	fio) cc -t testing -r git://git.kernel.dk/fio.git @@configure --build-static @b fio @m fio ;;
	gdu) go -t testing -r https://github.com/dundee/gdu.git @m ./cmd/gdu ;;
	gomplate) go -t testing -r https://github.com/hairyhenderson/gomplate.git @m ./cmd/gomplate ;;
	gotop) go -t testing -r https://github.com/xxxserxxx/gotop.git @m ./cmd/gotop ;;
	handlr) rust -t testing -r https://github.com/chmln/handlr.git @b handlr ;;
	hyperfine) rust -t testing -r https://github.com/sharkdp/hyperfine.git @b hyperfine ;;
	janet) cc -t testing -r https://github.com/janet-lang/janet.git -m all -b build/janet @o mimalloc ;;
	jo) cc -t testing -r https://github.com/jpmens/jo.git @o autoreconf @o configure -m jo -b jo @o mimalloc ;;
	less) cc -t testing -r https://github.com/gwsw/less.git @o autoreconf @@configure --with-regex=pcre2 @b less @o mimalloc ;;
	libarchive) cc -t testing -r https://github.com/libarchive/libarchive.git @o autoreconf @m bsdtar \
				@@apk xz-dev @@apk bzip2-dev @@apk zlib-dev @@apk libb2-dev @@apk lz4-dev @@apk zstd-dev \
				@@apk xz-dev @@apk lzo-dev @@apk nettle-dev @@apk libxml2-dev @@apk expat-dev @o mimalloc \
				@@configure --enable-bsdtar=static @@configure --disable-bsdcat @@configure --disable-bsdcpio ;;
	lua) cc -t testing -r https://github.com/lua/lua.git @o u @b lua @o mimalloc ;;
	minisign) cc -t testing -r https://github.com/jedisct1/minisign.git @@apk libsodium-dev \
			  @@cmake -D @@cmake BUILD_STATIC_EXECUTABLES=1 -m all -b minisign ;;
	monolith) rust -t testing -r https://github.com/Y2Z/monolith.git @b monolith ;;
	mrsh) cc -t testing -r https://github.com/emersion/mrsh.git @@configure --static @m mrsh @b mrsh @o u @o mimalloc ;;
	nmap) cc -t testing -r https://github.com/nmap/nmap.git @b ncat/ncat @o mimalloc ;;
	pastel) rust -t testing -r https://github.com/sharkdp/pastel.git @b pastel ;;
	pup) go -t testing -r https://github.com/ericchiang/pup.git @m . ;;
	rsync) cc -t testing -r https://github.com/WayneD/rsync.git @o autoreconf @m reconfigure @m rsync @b rsync \
		   @@apk acl-dev @@apk lz4-dev @@apk zlib-dev @@apk zstd-dev @o mimalloc \
		   @@configure --disable-xxhash @@configure --disable-md2man ;;
	sd) rust -t testing -r https://github.com/chmln/sd.git @b sd ;;
	sic) rust -t testing -r https://github.com/foresterre/sic.git @@apk nasm -b sic ;;
	sixel) cc -t testing -r https://github.com/saitoha/libsixel.git @m all @b converters/img2sixel @o mimalloc \
		   @b converters/sixel2png @@apk gd-dev @@apk libjpeg-turbo-dev @@apk libpng-dev @o configure ;;
	socat) cc -t testing -r git://repo.or.cz/socat.git @b socat @o mimalloc ;;
	tmux) cc -t testing -r https://github.com/tmux/tmux.git @@apk libevent-dev \
		  @o autogen.sh @o configure @b tmux @m all @o mimalloc ;;
	toybox) cc -t testing -r https://github.com/landley/toybox.git @o u @b toybox ;;
	websocat) rust -t testing -r https://github.com/vi/websocat.git @b websocat @@rfeatures ssl ;;
	zstd) cc -t testing -r https://github.com/facebook/zstd.git @@apk lz4-dev @@apk xz-dev @m zstd @o mimalloc ;;

	# Server
	caddy) go -t server -r https://github.com/caddyserver/caddy.git @m ./cmd/caddy ;;
	dnsmasq) cc -t server -r git://thekelleys.org.uk/dnsmasq.git @b src/dnsmasq @o mimalloc ;;
	dropbear) cc -t server -r https://github.com/mkj/dropbear.git @o autoreconf @m all @o mimalloc \
			  @@configure --enable-static @b dbclient @b dropbear @b dropbearconvert @b dropbearkey ;;
	echoip) go -t server -r https://github.com/mpolden/echoip.git @m ./cmd/echoip ;;
	gobgp) go -t server -r https://github.com/osrg/gobgp.git @m ./cmd/gobgp @m ./cmd/gobgpd ;;
	meilisearch)  rust -t server -r https://github.com/meilisearch/MeiliSearch.git @b meilisearch ;;
	miniflux) go -t server -r https://github.com/miniflux/v2.git -m miniflux -b miniflux -n miniflux ;;
	minio) go -t server -r https://github.com/minio/minio.git @m . ;;
	minio-console) go -t server -r https://github.com/minio/console.git @o rename -m ./cmd/console -b minio-console -n minio-console ;;
	redir) cc -t server -r https://github.com/troglobit/redir.git @o autogen.sh @o configure @o u -m redir ;;
	unbound) cc -t server -r https://github.com/NLnetLabs/unbound.git @m unbound @o mimalloc \
			 @@apk expat-dev @@configure --enable-fully-static @@configure --prefix=/ ;;
	yggdrasil) go -t server -r https://github.com/yggdrasil-network/yggdrasil-go.git @m ./cmd/yggdrasil @m ./cmd/yggdrasilctl ;;
	esac
done

# currently failing due to a segfault in build-script-build, cause unknown
# starship) rust -t testing -r https://github.com/starship/starship.git -b starship ;;
