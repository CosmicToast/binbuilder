apk add ncurses-dev readline-dev
make CC="$CC" MYLDFLAGS="$LDFLAGS" MYLIBS="-ldl -lncursesw -lreadline"
bin=lua
