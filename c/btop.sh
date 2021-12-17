apk add gcc # shouldn't be needed once clang gets ranges ts
make LDFLAGS="$LDFLAGS -fuse-ld=lld" STATIC=true CXX=gnu-g++
