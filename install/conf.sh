#!/bin/sh
cd $HOME/vim_src/vim/src
make autoconf
cd ../
./configure \
  --with-features=huge \
  --disable-selinux \
  --enable-gui=auto \
  --enable-multibyte \
  --enable-pythoninterp \
  --enable-rubyinterp \
  --enable-luainterp \
  --with-lua-prefix=/usr \
  --with-luajit \
  --enable-fontset \
  --enable-fail-if-missing
