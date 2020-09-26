FROM abyssos/abyss
RUN apk add --no-cache \
	# tools
	autoconf automake cmake git gmake libtool lld pkgconf \
	# libs
	clang-dev libcxx-dev llvm-dev musl-dev linux-dev
RUN [ "/usr/bin/ln", "-s", "/usr/bin/gmake", "/usr/bin/make" ]
RUN [ "/usr/bin/ln", "-s", "/usr/bin/llvm-strip", "/usr/bin/strip" ]
ENV AR=llvm-ar AS=clang CC=clang CXX=clang++ LD=ld.lld \
	CFLAGS="-Os -pipe" CXXFLAGS="-Os -pipe" LDFLAGS="-Wl,-O1 -Wl,--as-needed"
