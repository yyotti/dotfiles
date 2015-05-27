#!/bin/sh
# vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:

# 環境ごとの設定 {{{
__VIM_ENABLE_GUI=no

__LUAJIT_PREFIX="$HOME/opt"
# }}}

# パッケージインストール関数定義 {{{
install_pkg() {
  root_exec yum -y install $@
}
# }}}

# ライブラリインストール関数定義 {{{
install_libs() {
  # Vimのビルドに必要
  #   - "Development Tools"(Ubuntu の build-essential に相当)
  #   - gettext
  #   - ncurses-devel
  # その他、スクリプト言語
  #   - lua-devel (+lua)
  #   - perl-devel (+perl)
  #   - python-devel (+python)
  #   - ruby-devel (+ruby)
  #   - tcl-devel (+tcl)

  root_exec yum -y groupinstall "Development Tools"
  _res=$?
  if [ $_res -ne 0 ]; then
    error 'Development Tools をインストールできませんでした'
    return $_res
  fi

  install_pkg \
    gettext \
    ncurses-devel \
    lua-devel \
    python-devel \
    ruby-devel
  _res=$?
  if [ $_res -ne 0 ]; then
    return $_res
  fi

  # luajit はコンパイルしなければならない
  #   - luajit (+lua)
  if [ `which git` ]; then
    git clone http://luajit.org/git/luajit-2.0.git /tmp/luajit
    _res=$?
    if [ $_res -ne 0 ]; then
      error 'luajit を clone できませんでした'
      return $_res
    fi

    _current=`pwd`
    cd /tmp/luajit

    if [ "x$__LUAJIT_PREFIX" = "x" ]; then
      __LUAJIT_PREFIX='/usr/local'
    fi

    make clean
    if [ $__CPU_CORE_NUM -lt 2 ]; then
      make PREFIX="$__LUAJIT_PREFIX"
    else
      make PREFIX="$__LUAJIT_PREFIX" -j $__CPU_CORE_NUM
    fi
    _res=$?
    if [ $_res -ne 0 ]; then
      error 'luajit を make できませんでした'
      return $_res
    fi

    if [ -w "$__LUAJIT_PREFIX" ]; then
      make install PREFIX="$__LUAJIT_PREFIX"
    else
      root_exec make install PREFIX="$__LUAJIT_PREFIX"
    fi
    _res=$?
    if [ $_res -ne 0 ]; then
      error 'luajit をインストールできませんでした'
      return $_res
    fi

    cd $_current
  fi
}
# }}}
