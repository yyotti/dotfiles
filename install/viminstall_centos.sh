#!/bin/sh
# vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:

# 環境ごとの設定 {{{
__VIM_ENABLE_GUI=no
# }}}

# パッケージインストール関数定義 {{{
install_pkg() {
  root_exec yum -y install $@
}
# }}}

# ライブラリインストール関数定義 {{{
install_libs() {
  # TODO たぶん luajit はコンパイルしなければならない

  # TODO 以下は apt-get の場合の名前
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
  #   - phthon3-dev (+python3)
  #   - ruby-dev (+ruby)
  #   - tcl-dev (+tcl)

  # TODO
  # install_pkg \
  #   build-essential \
  #   gettext \
  #   libncurses5-dev \
  #   xorg-dev \
  #   libgtk2.0-dev \
  #   liblua5.1-dev \
  #   luajit \
  #   libluajit-5.1-dev \
  #   libperl-dev \
  #   python-dev \
  #   python3-dev \
  #   ruby-dev \
  #   tcl-dev
}
# }}}
