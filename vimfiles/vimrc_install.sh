# 現在のカレントを退避
current=`pwd`

# このファイルがあるディレクトリに移動する
cd `dirname $0`

# vimrcとgvimrcのシンボリックリンクをホームディレクトリに作成する
if [ ! -e ~/.vimrc ]; then
	ln -s `pwd`/vimrc ~/.vimrc
fi
if [ ! -e ~/.gvimrc ]; then
	ln -s `pwd`/gvimrc ~/.gvimrc
fi

# バックアップディレクトリ等を作成する
if [ ! -e ~/.vim/.backup ]; then
	mkdir -p ~/.vim/.backup
fi

# neobundleをインストールする
if [ ! -e ~/.vim/bundle ]; then
	curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
fi

# 最初のカレントに戻る
cd ${current}
