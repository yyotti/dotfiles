#!/bin/sh

readonly BASE_DIR=$(cd $(dirname $0) && pwd)
cd $BASE_DIR

readonly TARGET_DIR=$(cd ~ && pwd)

msg() {
  color=$1
  shift
  echo "\033${color}m$@\033[0m"
}

info() {
  msg '[0;37' $1
}

warn() {
  msg '[1;33' $1
}

for file in `ls -a`
do
  if expr "$file" : "^\.[^.]\+$" > /dev/null ; then  # ドットファイルのみを対象とする
    info "$fileのシンボリックリンクを生成します"

    target=$TARGET_DIR/$file
    if [ -L $target ]; then  # 同名のシンボリックリンクが存在
      warn "$fileがシンボリックリンクとして存在しています。削除して置き換えますか？(y/n)"
      read ans
      if [ $ans = 'y' -o $ans = 'Y' ]; then
        rm -f $target
        ln -s $BASE_DIR/$file $target
        info "$fileのシンボリックリンクを生成しました"
      fi
    elif [ -d $target ]; then  # 同名のディレクトリが存在
      warn "$fileがディレクトリとして存在しています。削除して置き換えますか？(y/n)"
      read ans
      if [ $ans = 'y' -o $ans = 'Y' ]; then
        rm -fR $target
        ln -s $BASE_DIR/$file $target
        info "$fileのシンボリックリンクを生成しました"
      fi
    elif [ -f $target ]; then  # 同名の通常ファイルが存在
      warn "$fileが通常ファイルとして存在しています。削除して置き換えますか？(y/n)"
      read ans
      if [ $ans = 'y' -o $ans = 'Y' ]; then
        rm -f $target
        ln -s $BASE_DIR/$file $target
        info "$fileのシンボリックリンクを生成しました"
      fi
    else  # ファイルが存在しなければ処理
      ln -s $BASE_DIR/$file $target
      info "$fileのシンボリックリンクを生成しました"
    fi
  fi
done


