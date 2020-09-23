FROM rust
RUN rustup toolchain add nightly
RUN rustup default nightly
RUN rustup target add $(uname -m)-unknown-linux-musl
RUN apt-get -y update && apt-get -y install \
	clang
ENV CC=clang CFLAGS="-Os -pipe" CXXFLAGS="-Os -pipe" LDFLAGS="-Wl,-O1 -Wl,--as-needed"
