FROM abyssos/abyss
RUN apk add --no-cache \
	clang-dev cmake git gmake libcxx-dev lld llvm-dev musl-dev linux-dev
RUN [ "/usr/bin/ln", "-s", "/usr/bin/gmake", "/usr/bin/make" ]
RUN [ "/usr/bin/ln", "-s", "/usr/bin/llvm-strip", "/usr/bin/strip" ]
ENV AR=llvm-ar AS=clang CC=clang CXX=clang++ LD=ld.lld \
	CFLAGS="-Os -pipe" CXXFLAGS="-Os -pipe" LDFLAGS="-Wl,-O1 -Wl,--as-needed"
