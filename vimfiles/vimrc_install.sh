#!/bin/sh

# 現在のカレントを退避
current=`pwd`

# このファイルがあるディレクトリに移動する
cd `dirname $0`

info() {
  echo 'info:' $1
}

warn() {
  echo 'warn:' $1
}

mklink() {
  file=$1
  info "$fileのシンボリックリンクを生成します"

  target=$2
  if [ -L $target ]; then  # 同名のシンボリックリンクが存在
    warn "$targetがシンボリックリンクとして存在しています。削除して置き換えますか？(y/n)"
    read ans
    if [ $ans = 'y' -o $ans = 'Y' ]; then
      rm -f $target
      ln -s $file $target
      info "$fileのシンボリックリンクを生成しました"
    fi
  elif [ -d $target ]; then  # 同名のディレクトリが存在
    warn "$targetがディレクトリとして存在しています。削除して置き換えますか？(y/n)"
    read ans
    if [ $ans = 'y' -o $ans = 'Y' ]; then
      rm -fR $target
      ln -s $file $target
      info "$fileのシンボリックリンクを生成しました"
    fi
  elif [ -f $target ]; then  # 同名の通常ファイルが存在
    warn "$targetが通常ファイルとして存在しています。削除して置き換えますか？(y/n)"
    read ans
    if [ $ans = 'y' -o $ans = 'Y' ]; then
      rm -f $target
      ln -s $file $target
      info "$fileのシンボリックリンクを生成しました"
    fi
  else  # ファイルが存在しなければ処理
    ln -s $file $target
    info "$fileのシンボリックリンクを生成しました"
  fi
}

make_dir() {
  info "ディレクトリ $1 を生成します"
  if [ ! -e $1 ]; then
    mkdir -p $1
    info "ディレクトリ $1 を生成しました"
  else
    info "ディレクトリ $1 は既に存在しています"
  fi
}

# vimrcとgvimrcのシンボリックリンクをホームディレクトリに作成する
mklink `pwd`/vimrc ~/.vimrc
mklink `pwd`/gvimrc ~/.gvimrc

# skkディレクトリのシンボリックリンクをホームディレクトリに作成する
make_dir ~/.skk
mklink `pwd`/skk/SKK-JISYO.L ~/.skk/SKK-JISYO.L

# バックアップディレクトリ等を作成する
make_dir ~/.vim/.backup

if [ `which git` ]; then
  # gitのための設定を行う
  git config --global diff.algorithm "histogram"
  git config --global diff.tool "vimdiff"

  if [ `which ctags` ]; then
    # ctagsを使えるようにする
    mklink `pwd`/ctags ~/.ctags
    mklink `pwd`/git_tmp ~/.git_tmp
    git config --global init.templatedir "~/.git_tmp"
  fi
fi

# 最初のカレントに戻る
cd ${current}

# vim:set ts=8 sts=2 sw=2 tw=0 foldmethod=marker:
