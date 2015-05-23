#!/bin/sh
# vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:

# 環境ごとの設定 {{{
__VIM_ENABLE_GUI=gtk2
# }}}

# パッケージインストール関数定義 {{{
install_pkg() {
  root_exec apt-get -y install $@
}
# }}}

# ライブラリインストール関数定義 {{{
install_libs() {
  # Vimのビルドに必要
  #   - build-essential
  #   - gettext
  #   - libncurses5-dev
  # Gvimのビルドに必要
  #   - xorg-dev
  #   - libgtk2.0-dev
  # その他、スクリプト言語
  #   - liblua5.1-dev (+lua)
  #   - luajit (+lua)
  #   - libluajit-5.1-dev (+lua)
  #   - libperl-dev (+perl)
  #   - phthon-dev (+python)
  #   - ruby-dev (+ruby)
  #   - tcl-dev (+tcl)
  install_pkg \
    build-essential \
    gettext \
    libncurses5-dev \
    xorg-dev \
    libgtk2.0-dev \
    liblua5.1-dev \
    luajit \
    libluajit-5.1-dev \
    python-dev \
    ruby-dev \
}
# }}}
