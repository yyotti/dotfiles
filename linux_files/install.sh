#!/bin/sh

# まずはホームディレクトリからスタート
cd $HOME

###########################################################
# 定数設定
###########################################################
readonly GIT_BASE_DIR=$HOME/git    # gitディレクトリ
readonly SETTING_DIR=$GIT_BASE_DIR/linux_settings    # 設定リポジトリ

#----------------------------------------------------------
# infoログ（標準出力）
#----------------------------------------------------------
info() {
    echo "$1"
}

#----------------------------------------------------------
# warnログ（標準出力）
#----------------------------------------------------------
warn() {
    echo "\033[1;33m$1\033[0m"
}

#----------------------------------------------------------
# errorログ（標準出力）
#----------------------------------------------------------
error() {
    echo "\033[1;31m$1\033[0m"
}

#----------------------------------------------------------
# コマンドが無ければ終了する
#----------------------------------------------------------
check_cmd_and_exit() {
    if [ ! `which $1` ]; then
        error "コマンド '$1' がありません"
        exit 1
    fi
}

create_link() {
    info "$fileのシンボリックリンクを生成します"

    local target=$2/$1
    if [ ! -e $target ]; then  # ファイルが存在しなければ処理
        ln -s $file $target
        info "$fileのシンボリックリンクを生成しました"
    elif [ -L $target ]; then  # 同名のシンボリックリンクが存在
        warn "$fileがシンボリックリンクとして存在しています。削除して置き換えますか？(y/n)"
        read ans
        if [ $ans = 'y' -o $ans = 'Y' ]; then
            rm -f $target
            ln -s $file $target
            info "$fileのシンボリックリンクを生成しました"
        fi
    elif [ -d $target ]; then  # 同名のディレクトリが存在
        warn "$fileがディレクトリとして存在しています。削除して置き換えますか？(y/n)"
        read ans
        if [ $ans = 'y' -o $ans = 'Y' ]; then
            rm -fR $target
            ln -s $file $target
            info "$fileのシンボリックリンクを生成しました"
        fi
    elif [ -f $target ]; then  # 同名の通常ファイルが存在
        warn "$fileが通常ファイルとして存在しています。削除して置き換えますか？(y/n)"
        read ans
        if [ $ans = 'y' -o $ans = 'Y' ]; then
            rm -f $target
            ln -s $file $target
            info "$fileのシンボリックリンクを生成しました"
        fi
    fi
}

###########################################################
# 設定をダウンロード
###########################################################
download() {
    ## gitディレクトリを生成
    if [ ! -e $GIT_BASE_DIR ]; then
        info "$GIT_BASE_DIRを生成します"
        mkdir $GIT_BASE_DIR
        info "$GIT_BASE_DIRを生成しました"
    fi

    ## 自分の設定を git clone
    info "チェックアウト中です"
    git clone https://github.com/tosakamaru/dotfiles.git $SETTING_DIR
    info "チェックアウト終了"
}

###########################################################
# Vimの設定
###########################################################
init_vim() {
    # ドットファイルのシンボリックリンクを作成
    local base_dir=$(cd $(dirname $SETTING_DIR/dotfiles) && pwd)
    cd $base_dir

    local target_dir=$(cd $HOME && pwd)

    for file in `ls -a | egrep vim\|ctags`
    do
        if expr "$file" : "^\.[^.]\+$" > /dev/null ; then  # ドットファイルのみを対象とする
            create_link $base_dir/$file $target_dir
        fi
    done

	## TODO いったん.vimrcを削除し、初期化用のバンドル設定のものだけにする

    if [ ! -e $HOME/.vim/bundle ]; then
        info "＄HOME/.vimディレクトリを生成します"
        mkdir -p $HOME/.vim/bundle
        info "＄HOME/.vimディレクトリを生成しました"
    fi
    # NeoBundleをインストール
    info "NeoBundleプラグインをチェックアウトします"
	git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
    info "NeoBundleプラグインをチェックアウトしました"

	## NeoBundleInstall
	info "プラグインをインストールします"
	vim -c NeoBundleInstall -c q
	info "プラグインのインストールが完了しました"

	## TODO .vimrcを本物にする

    cd $HOME
}

## 今後の設定で必要なコマンドの存在確認
info "必要なコマンドが揃っているか確認します"
check_cmd_and_exit "git"
info "必要なコマンドは全て揃っています"

## 設定ダウンロード
info "設定リポジトリをチェックアウトします"
download
info "設定リポジトリをチェックアウトしました"

## Vimの存在確認
if [ ! `which vim` ]; then
    ## あれば設定
    info "Vim/GVimの設定を行います"
    init_vim
    info "Vim/GVimの設定が完了しました"
fi

## TODO .bashrcをコピーしてsource
