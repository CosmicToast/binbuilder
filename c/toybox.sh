apk add bash
m() make HOSTCC=$CC LDFLAGS="$LDFLAGS" "$@"
cset() sed .config -i -e "/$1\b/s/.*/$1=$2/"

m distclean defconfig -j1

cset CONFIG_W n
cset CONFIG_WHO n
m silentoldconfig

m toybox
bin=toybox
