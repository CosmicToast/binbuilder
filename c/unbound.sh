apk add expat-dev
# prefix / so it uses /etc/unbound.conf
AR=/bin/llvm-ar ./configure --enable-fully-static --prefix=/
make
bin=unbound
