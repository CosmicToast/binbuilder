#!/bin/zsh -e
# zsh for main detection

# builder functions
# $1 is url
# $2 is page name
# $3 is manual section

dir='manuals'
prefix="$dir/man"

pre() {
	echo "$2.$3"
	mkdir -p "$prefix$3"
}

# bare file
bare() {
	pre "$@"
	ht -Fb "$1" > "$prefix$3/$2.$3"
}

scd() {
	pre "$@"
	ht -Fb "$1" | scdoc > "$prefix$3/$2.$3"
}

# if we're being sourced, this is it
(( $#zsh_eval_context > 1 )) && return

# bash
bare https://git.savannah.gnu.org/cgit/bash.git/plain/doc/bash.1 bash 1

# cmark
bare https://raw.githubusercontent.com/commonmark/cmark/master/man/man1/cmark.1 cmark 1
bare https://raw.githubusercontent.com/commonmark/cmark/master/man/man3/cmark.3 cmark 3

# dropbear
bare https://raw.githubusercontent.com/mkj/dropbear/master/dbclient.1 dbclient 1
bare https://raw.githubusercontent.com/mkj/dropbear/master/dropbear.8 dropbear 8
bare https://raw.githubusercontent.com/mkj/dropbear/master/dropbearconvert.1 dropbearconvert 1
bare https://raw.githubusercontent.com/mkj/dropbear/master/dropbearkey.1 dropbearkey 1

# entr
bare https://raw.githubusercontent.com/eradman/entr/master/entr.1 entr 1

# fd
bare https://raw.githubusercontent.com/sharkdp/fd/master/doc/fd.1 fd 1

# foot
scd https://codeberg.org/dnkl/foot/raw/branch/master/doc/foot.1.scd       foot       1
scd https://codeberg.org/dnkl/foot/raw/branch/master/doc/foot.ini.5.scd   foot.ini   5
scd https://codeberg.org/dnkl/foot/raw/branch/master/doc/footclient.1.scd footclient 1

# fzf
bare https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf.1 fzf 1

# hyperfine
bare https://raw.githubusercontent.com/sharkdp/hyperfine/master/doc/hyperfine.1 hyperfine 1

# jo
bare https://github.com/jpmens/jo/blob/master/jo.1 jo 1

# jq
bare https://raw.githubusercontent.com/stedolan/jq/master/jq.1.prebuilt jq 1

# minisign
bare https://raw.githubusercontent.com/jedisct1/minisign/master/share/man/man1/minisign.1 minisign 1

# mksh
bare https://raw.githubusercontent.com/MirBSD/mksh/master/lksh.1 lksh 1
bare https://raw.githubusercontent.com/MirBSD/mksh/master/mksh.1 mksh 1

# nmap
bare https://raw.githubusercontent.com/nmap/nmap/master/ncat/docs/ncat.1 ncat 1

# rc
bare https://raw.githubusercontent.com/muennich/rc/master/rc.1 rc 1

# rclone
bare https://raw.githubusercontent.com/rclone/rclone/master/rclone.1 rclone 1

# restic
for i in backup cache cat check diff dump find forget generate init key list ls migrate mount prune rebuild-index recover restore self-update snapshots stats tag unlock version
	bare https://raw.githubusercontent.com/restic/restic/master/doc/man/restic-$i.1 restic-$i 1
bare https://raw.githubusercontent.com/restic/restic/master/doc/man/restic.1 restic 1

# samurai
bare https://raw.githubusercontent.com/michaelforney/samurai/master/samu.1 samu 1

# scdoc
scd https://git.sr.ht/~sircmpwn/scdoc/blob/master/scdoc.1.scd scdoc 1
scd https://git.sr.ht/~sircmpwn/scdoc/blob/master/scdoc.5.scd scdoc 5

# skim
for i in sk sk-tmux
	bare https://raw.githubusercontent.com/lotabout/skim/master/man/man1/$i $i 1

# watchexec
bare https://raw.githubusercontent.com/watchexec/watchexec/main/doc/watchexec.1 watchexec 1

# zstd
bare https://raw.githubusercontent.com/facebook/zstd/dev/programs/zstd.1 zstd 1

# ---- compress!
find "$dir" -type f -exec gzip '{}' +
