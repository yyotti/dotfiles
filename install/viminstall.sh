#!/bin/sh
# vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:

__SCRIPT_DIR=`dirname $0`

# 共通関数などをインクルード
. "$__SCRIPT_DIR/common.sh"

# 設定 {{{

# Vim ソースの取得元など {{{
__VIM_REPO='https://vim.googlecode.com/hg'
__PATCH_REPO='https://bitbucket.org/koron/vim-kaoriya-patches'
__CLONE_DIR="$HOME"
# }}}

# ビルドするバージョンの定義 {{{

# タグかリビジョンのどちらかで指定する
__VIM_VERSION_TAG='v7-4-648'
__PATCH_HASH='4b5bd3b04e84'

# }}}

# configure/make のための設定 {{{

# Vim のインストール先
# - デフォルトでは /usr/local になる。
# - 実行ファイル以外のファイルが __VIM_PREFIX/share などにインストールされる。
# __VIM_PREFIX="$HOME/opt"

# Vim + 関連コマンドのインストール先
# - デフォルトでは __VIM_PREFIX の値が使われる。
# - コマンド郡が $__VIM_EXEC_PREFIX/bin にインストールされる。
# - __VIM_PREFIX もデフォルトなら、 /usr/local/bin にインストールされる。
# __VIM_EXEC_PREFIX="$HOME"

# GVim もコンパイルするか
# - 下記のいずれかに設定する
# - デフォルトは auto 、コンパイルしないなら no
#   auto/no/gtk2/gnome2/motif/athena/neXtaw/photon/carbon
#__VIM_ENABLE_GUI=no

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
  . "$__SCRIPT_DIR/viminstall_centos.sh"
elif [ $__OS = 'ubuntu' ]; then
  # Ubuntu/Linux Mint
  . "$__SCRIPT_DIR/viminstall_ubuntu.sh"
else
  # TODO cygwinどうするか？
  error 'OSが不明もしくは対応していないOSです'
  exit 1
fi
# }}}

# Mercurialをインストールする {{{
if [ ! `which hg` ]; then
  info 'Mercurial をインストールします'
  install_pkg mercurial
  if [ $? -ne 0 ]; then
    error 'Mercurial のインストールに失敗しました'
    exit 1
  fi
fi
# }}}

# $HOMEに .hgrc を作成する {{{
if [ ! -e $HOME/.hgrc ]; then
  info "$HOME/.hgrc を作成します"
  echo "[ui]
username = tsutsui
[extensions]
mq=" > $HOME/.hgrc
fi
# }}}

# Vimのソースを clone するディレクトリを掃除 {{{
rm -fR "$__CLONE_DIR/vim"
if [ ! -e "$__CLONE_DIR" ]; then
  mkdir -p $__CLONE_DIR
fi
cd $__CLONE_DIR
# }}}

# vimのソースとkaoriyaパッチをcloneする {{{
info 'Vim のソースと kaoriya パッチを clone します'
hg qclone $__VIM_REPO ./vim -p $__PATCH_REPO
if [ $? -ne 0 ]; then
  error 'clone に失敗しました'
  exit 1
fi
# }}}

# ソースとパッチを特定のリビジョンにして branch を作成 {{{
cd $__CLONE_DIR/vim

info "対象のリビジョンに変更します"
info "Vim version: $__VIM_VERSION_TAG"
info "Patch version: $__PATCH_HASH"
hg update "$__VIM_VERSION_TAG"
hg update "$__PATCH_HASH" --mq

__BRANCH_NAME=`echo "$__VIM_VERSION_TAG" | sed 's/v\([0-9]*\)-\([0-9]*\)-\([0-9]*\)/kaoriya-\1.\2.\3/'`
info "ブランチを作成します"
info "branch name: $__BRANCH_NAME"
hg branch "$__BRANCH_NAME"
# }}}

# パッチを当てる {{{
info 'パッチを適用します'
hg qpush -a
if [ $? -ne 0 ]; then
  error 'パッチを正常に当てられませんでした'
  exit 1
fi
# }}}

# ビルドに必要なライブラリやruby等をインストールする {{{
# TODO 不要なものは入れたくないので、+rubyとかが必要か検討
#      luajitはパッケージが無いので、ダウンロード＆コンパイルしなければならない
info '必要なライブラリをインストールします'
install_libs
if [ $? -ne 0 ]; then
  error 'ライブラリインストール中にエラーが発生しました'
  exit 1
fi
# }}}

# configureする {{{
# TODO インストール先は $HOME/bin でいいが、/usr/local/shareなどのことを考えると $HOME/local や $HOME/opt のほうがいいか？
#      それなら git もそうするが・・・
#      ただ、$HOME/local とかにすると、パスを通す必要があるかもしれない。インストール先と実体が分かれるオプションを探したい。
info 'configure を実行します'
if [ "x$__VIM_PREFIX" = "x" ]; then
  __VIM_PREFIX=/usr/local
fi
if [ "x$__VIM_EXEC_PREFIX" = "x" ]; then
  __VIM_EXEC_PREFIX=$__VIM_PREFIX
fi
if [ "x$__VIM_ENABLE_GUI" = "x" ]; then
  __VIM_ENABLE_GUI=auto
fi

rm -f src/auto/config.cache
./configure \
  --prefix="$__VIM_PREFIX" \
  --exec-prefix="$__VIM_EXEC_PREFIX" \
  --with-features=huge \
  --disable-selinux \
  --enable-gui="$__VIM_ENABLE_GUI" \
  --enable-multibyte \
  --enable-pythoninterp \
  --enable-rubyinterp \
  --enable-luainterp \
  --with-lua-prefix=/usr \
  --with-luajit \
  --enable-fontset \
  --enable-fail-if-missing
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
info "Vim をインストールします  インストール先: $__VIM_PREFIX"
if [ -w "$__VIM_PREFIX" ]; then
  make install
else
  root_exec make install
fi
if [ $? -ne 0 ]; then
  error 'インストール中にエラーが発生しました'
  exit 1
fi

# いったん info を出す
info 'Vim のインストールが完了しました。'
# }}}

# kaoriya-Vim をダウンロード {{{
if [ ! `which wget` ]; then
  info 'wget をインストールします'
  install_pkg wget
  if [ $? -ne 0 ]; then
    warn 'wget をインストールできませんでした'
    warn 'vim74-kaoriya-win32 をダウンロードし、必要なファイルをコピーしてください'
    exit 1
  fi
fi

info 'vim74-kaoriya-win32 をダウンロードします'
wget -q -O /tmp/vim-kaoriya.zip http://files.kaoriya.net/goto/vim74w32
if [ $? -ne 0 ]; then
  error "ダウンロード中にエラーが発生しました"
  exit 1
fi
# }}}

# kaoriya-Vim を解凍して必要なファイルをコピー {{{
info 'kaoriya-Vim から必要なファイルをコピーします'
unzip /tmp/vim-kaoriya.zip
if [ $? -ne 0 ]; then
  error 'kaoriya-Vim のアーカイブを展開できませんでした。'
  error 'この後の設定は手動で行ってください。'
  exit 1
fi

__VIM_DIR=$__VIM_PREFIX/share/vim/vim74
__VIM_KAORIYA=./vim74-kaoriya-win32
if [ ! -w "$__VIM_PREFIX/share" -o ! -w "$__VIM_PREFIX/share/vim" ]; then
  __ROOT_EXEC=root_exec
fi

if [ -e "${__VIM_DIR}.bak" ]; then
  $__ROOT_EXEC rm -fR ${__VIM_DIR}.bak
  if [ $? -ne 0 ]; then
    error "前回バックアップしたディレクトリ ${__VIM_DIR}.bak を削除できませんでした。"
    error 'この後の設定は手動で行ってください。'
    exit 1
  fi
fi

$__ROOT_EXEC mv $__VIM_DIR ${__VIM_DIR}.bak
if [ $? -ne 0 ]; then
  error "${__VIM_DIR} をリネームできませんでした。"
  error 'この後の設定は手動で行ってください。'
  exit 1
fi

$__ROOT_EXEC mv \
  vim74-kaoriya-win32/switches \
  vim74-kaoriya-win32/origdoc \
  vim74-kaoriya-win32/vim74 \
  vim74-kaoriya-win32/plugins \
  vim74-kaoriya-win32/gvimrc \
  vim74-kaoriya-win32/vimrc \
  "$__VIM_PREFIX/share/vim/"
if [ $? -ne 0 ]; then
  error 'kaoriya-Vim の付属ファイルの一部もしくは全てをコピーできませんでした。'
  error 'この後の設定は手動で行ってください。'
  exit 1
fi

rm -fR "$__VIM_KAORIYA"
# }}}

# この時点でできる Vim の設定 {{{
info 'switches/catalog/utf-8.vim を有効にします'
$__ROOT_EXEC ln -s "$__VIM_PREFIX/share/vim/switches/catalog/utf-8.vim" "$__VIM_PREFIX/share/vim/switches/enabled/utf-8.vim"
if [ $? -ne 0 ]; then
  error 'シンボリックリンクを作成できませんでした。手動で utf-8 を有効にしてください。'
  exit 1
fi
# }}}

info 'Vim のインストールが正常に完了しました'

exit 0
