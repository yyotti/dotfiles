#!/bin/sh
# vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:

# パッケージインストール関数定義 {{{
install_pkg() {
  root_exec apt-get -y install $@
}
# }}}

# ライブラリインストール関数定義 {{{
install_libs() {
  # libevent
  install_pkg libevent-dev
}
# }}}
