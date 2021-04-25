FROM binbuilder:base

# base dockerfile for anything that needs C things
# this means including rust!
# sets up all of the basics, other things can be added after

RUN apk add --no-cache \
	# tools
	autoconf autoconf-archive automake bash cmake file gettext-tiny \
	libtool pkgconf \
	# compiler libs
	libcxx-dev llvm-dev linux-dev musl-dev \
	# compiler compiler tools
	bison flex \
	# really common libraries, selected purely by feel
	ncurses-dev openssl-dev pcre2-dev readline-dev

# recognize as many utilities as possible by default
RUN [ "/usr/bin/ln", "-sf", "clang",       "/usr/bin/cc" ]
RUN [ "/usr/bin/ln", "-sf", "clang++",     "/usr/bin/cxx" ]
RUN [ "/usr/bin/ln", "-sf", "lld",         "/usr/bin/ld" ]
RUN [ "/usr/bin/ln", "-sf", "llvm-ar",     "/usr/bin/ar" ]
RUN [ "/usr/bin/ln", "-sf", "llvm-nm",     "/usr/bin/nm" ]
RUN [ "/usr/bin/ln", "-sf", "llvm-ranlib", "/usr/bin/ranlib" ]
RUN [ "/usr/bin/ln", "-sf", "llvm-strip",  "/usr/bin/strip" ]

# set up various C-related flags
# these are general recommendations, not tuned for bin-builder purposes
ENV AR=llvm-ar AS=clang CC=clang CXX=clang++ LD=ld.lld \
	CFLAGS="-Os -pipe" CXXFLAGS="-Os -pipe" LDFLAGS="-Wl,-O1, -Wl,--as-needed"
