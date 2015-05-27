#!/bin/sh
# vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:

# ライブラリインストール関数定義 {{{
install_libs() {
  root_exec yum -y groupinstall "Development Tools"
  _res=$?
  if [ $_res -ne 0 ]; then
    error 'Development Tools をインストールできませんでした'
    return $_res
  fi

  # libevent
  cd "$__SRC_DIR"
  wget https://sourceforge.net/projects/levent/files/libevent/libevent-2.0/libevent-2.0.22-stable.tar.gz
  _res=$?
  if [ $_res -ne 0 ]; then
    error 'libeventのソースをダウンロード中にエラーが発生しました'
    return $_res
  fi

  tar xzf libevent-2.0.22-stable.tar.gz
  cd libevent-2.0.22-stable
  ./configure
  _res=$?
  if [ $_res -ne 0 ]; then
    error 'libeventのconfigureでエラーが発生しました'
    return $_res
  fi
  make -j $__CPU_CORE_NUM
  root_exec make install
}
# }}}
