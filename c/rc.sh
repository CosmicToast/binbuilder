#!/bin/sh
apk add bison libedit-dev ncurses-dev
# both EDIT and LDLIBS need to be defined
# EDIT so that the correct .c file is included in OBJS
# LDLIBS to force adding ncursesw
# TODO: contribute to the hand-written makefile with the added system LIBS= :)
make EDIT=edit CC=clang YACC=yacc LDLIBS='-ledit -lncursesw' -j $(nproc)
bin=rc
