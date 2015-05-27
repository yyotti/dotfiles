#!/bin/sh
# vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:

__SCRIPT_DIR=`dirname $0`

# 共通関数などをインクルード
. "$__SCRIPT_DIR/common.sh"

# 設定 {{{

# 対象のバージョン {{{
__TMUX_VERSION='2.0'
# }}}

# ソースの取得元など {{{
__SRC_URL="http://downloads.sourceforge.net/tmux/tmux-${__TMUX_VERSION}.tar.gz"
__SRC_DIR='/tmp'
# }}}

# configure/make のための設定 {{{

# インストール先
# - デフォルトでは /usr/local になる。
# - 実行ファイル以外のファイルが __TMUX_PREFIX/share などにインストールされる。
__TMUX_PREFIX="$HOME/opt"

# tmuxコマンドのインストール先
# - デフォルトでは __TMUX_PREFIX の値が使われる。
# - コマンド郡が $__TMUX_EXEC_PREFIX/bin にインストールされる。
# - __TMUX_PREFIX もデフォルトなら、 /usr/local/bin にインストールされる。
__TMUX_EXEC_PREFIX="$HOME"

# make -j x のための設定。普通に make のみにするなら 1 以下にする。
__CPU_CORE_NUM=2

# }}}

# }}}

# sudo コマンドの存在チェック {{{
check_root
if [ $? -eq 1 ]; then
  if [ ! `which sudo` ]; then
    error 'sudo コマンドが存在しません。root 権限で実行してください。'
    exit 1
  else
    # sudoコマンドがある場合、それまでの認証をクリアする
    sudo -k
  fi
fi
# }}}

# パッケージマネージャの決定 {{{
__OS=`get_os_distribution`
if [ $__OS = 'redhat' ]; then
  # CentOS
  . "$__SCRIPT_DIR/tmuxinstall_centos.sh"
elif [ $__OS = 'ubuntu' ]; then
  # Ubuntu/Linux Mint
  . "$__SCRIPT_DIR/tmuxinstall_ubuntu.sh"
else
  # TODO cygwinどうするか？
  error 'OSが不明もしくは対応していないOSです'
  exit 1
fi
# }}}

# tmuxのソースをダウンロードするディレクトリを掃除 {{{
rm -fR "$__SRC_DIR/tmux-${__TMUX_VERSION}"
if [ ! -e "$__SRC_DIR" ]; then
  mkdir -p $__SRC_DIR
fi
rm -f "$__SRC_DIR/tmux-${__TMUX_VERSION}.tar.gz"
# }}}

# ソースをダウンロードする {{{
info 'ソースをダウンロードします'
cd $__SRC_DIR
wget $__SRC_URL
if [ $? -ne 0 ]; then
  error 'ソースのダウンロードに失敗しました'
  exit 1
fi
# }}}

# アーカイブを展開する {{{
info 'アーカイブを展開します'
tar xzf "tmux-${__TMUX_VERSION}.tar.gz"
# }}}

# 必要なライブラリをインストールする {{{
info '必要なライブラリをインストールします'
install_libs
if [ $? -ne 0 ]; then
  error 'ライブラリインストール中にエラーが発生しました'
  exit 1
fi
# }}}

# configureする {{{
info 'configure を実行します'
cd "tmux-${__TMUX_VERSION}"
if [ "x$__TMUX_PREFIX" = "x" ]; then
  __TMUX_PREFIX=/usr/local
fi
if [ "x$__TMUX_EXEC_PREFIX" = "x" ]; then
  __TMUX_EXEC_PREFIX=$__TMUX_PREFIX
fi

./configure \
  --prefix="$__TMUX_PREFIX" \
  --exec-prefix="$__TMUX_EXEC_PREFIX"
if [ $? -ne 0 ]; then
  error 'configure でエラーが発生しました'
  exit 1
fi
# }}}

# makeする {{{
info 'make を実行します'
make clean
if [ $__CPU_CORE_NUM -lt 2 ]; then
  make
else
  make -j $__CPU_CORE_NUM
fi
if [ $? -ne 0 ]; then
  error 'make 中にエラーが発生しました'
  exit 1
fi
# }}}

# インストール {{{
info "tmux をインストールします  インストール先: $__TMUX_PREFIX"
if [ -w "$__TMUX_PREFIX" ]; then
  make install
else
  root_exec make install
fi
if [ $? -ne 0 ]; then
  error 'インストール中にエラーが発生しました'
  exit 1
fi
# }}}

info 'tmux のインストールが正常に完了しました'

exit 0
