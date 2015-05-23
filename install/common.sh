#!/bin/sh
# vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:

# 色の定義 {{{
__COLOR_ERROR="\033[0;31m"
__COLOR_WARN="\033[0;33m"
__COLOR_INFO="\033[0;34m"
__COLOR_NORMAL="\033[0;39m"
# }}}

# メッセージ関数定義 {{{
error() { echo "${__COLOR_ERROR}[error] $@${__COLOR_NORMAL}"; }
warn() { echo "${__COLOR_WARN}[warn ] $@${__COLOR_NORMAL}"; }
info() { echo "${__COLOR_INFO}[info ] $@${__COLOR_NORMAL}"; }
# }}}

# OS関連 {{{
# http://qiita.com/koara-local/items/1377ddb06796ec8c628a
get_os_distribution() {
  if   [ -e /etc/debian_version ] || [ -e /etc/debian_release ]; then
    # Check Ubuntu or Debian
    if [ -e /etc/lsb-release ]; then
      # Ubuntu
      distri_name="ubuntu"
    else
      # Debian
      distri_name="debian"
    fi
  elif [ -e /etc/fedora-release ]; then
    # Fedra
    distri_name="fedora"
  elif [ -e /etc/redhat-release ]; then
    # CentOS
    distri_name="redhat"
  elif [ -e /etc/turbolinux-release ]; then
    # Turbolinux
    distri_name="turbol"
  elif [ -e /etc/SuSE-release ]; then
    # SuSE Linux
    distri_name="suse"
  elif [ -e /etc/mandriva-release ]; then
    # Mandriva Linux
    distri_name="mandriva"
  elif [ -e /etc/vine-release ]; then
    # Vine Linux
    distri_name="vine"
  elif [ -e /etc/gentoo-release ]; then
    # Gentoo Linux
    distri_name="gentoo"
  else
    # Other
    distri_name=""
  fi

  return $distri_name
}
# }}}

# root 関連 {{{
check_root() {
  _uid=`id | sed 's/uid=\([0-9]*\)(.*/\1/'`
  [ $_uid -eq 0 ]
  return $?
}

root_exec() {
  # root 権限でコマンドを実行する

  # root 権限のチェック
  check_root
  if [ $? -eq 0 ]; then
    # root なのでそのままインストール
    $@
  else
    if [ `which sudo` ]; then
      # sudo があるならそっちでやる
      sudo $@
    else
      # sudo がないなら root になる
      # ※ここには入ってほしくないので sudo できることを事前に確認する
      su root
      $@
    fi
  fi
}
# }}}
