# Linux環境構築メモ
Linux(主にLinux Mint/CentOS)で自分の環境を作るためのメモ。 （内容を[Wiki](https://github.com/yyotti/unix_settings/wiki)に移行中）

## ログインシェルをzshに変更する
[Wikiに移行済](https://github.com/yyotti/unix_settings/wiki/change_shell)

## ビルドツールをインストール
[Wikiに移行済](https://github.com/yyotti/unix_settings/wiki/install_build_tools)

## gitをインストール
[Wikiに移行済](https://github.com/yyotti/unix_settings/wiki/install_git)

## ドットファイルをインストールする
[Wikiに移行済](https://github.com/yyotti/unix_settings/wiki/install_dotfiles)

## tmuxをインストール

### パッケージマネージャでインストールする
バージョンが古い可能性が高いが、楽。

| OS                       | コマンド                    |
|:-------------------------|:----------------------------|
| Debian系([※1](#debian)) | `sudo apt-get install tmux` |
| redhat系([※2](#redhat)) | リポジトリにない            |

### ソースをビルドする
新しいバージョンを使える。yumの場合はこっちしか方法がない。

libevent2.xが必要なので、まずそっちをビルドする。

cursesが必要なのでインストール。

| OS                       | コマンド                                |
|:-------------------------|:----------------------------------------|
| Debian系([※1](#debian)) | `sudo apt-get install libncurses5-dev` |
| redhat系([※2](#redhat)) | `sudo yum install ncurses-devel`        |

その後、

```sh
cd /tmp
wget https://sourceforge.net/projects/levent/files/libevent/libevent-2.0/libevent-2.0.22-stable.tar.gz
tar xzf libevent-2.0.22-stable.tar.gz
cd libevent-2.0.22-stable
./configure
make -j 2
sudo make install
```
デフォルト以外の場所にインストールしたい場合は、`./configure`のときにインストール先を指定するオプションを加える。

libeventのインストールがうまくいったら、続いてtmuxをビルドする。
```sh
cd /tmp
wget http://downloads.sourceforge.net/tmux/tmux-2.0.tar.gz
tar xzf tmux-2.0.tar.gz
cd tmux-2.0
./configure
make -j 2
sudo make install
```
こちらも同じく、デフォルト以外の場所にインストールしたい場合は、`./configure`のときにインストール先を指定するオプションを加える。

libeventをソースからビルドした場合、tmux起動時に下記のようなエラーが出るかもしれない。(CentOS6では出た)
```
tmux: error while loading shared libraries: libevent-2.0.so.5: cannot open shared object file: No such file or directory
```
そのときは、下記のコマンドを実行する。
```sh
sudo ln -s /usr/local/lib/libevent-2.0.so.5 /usr/lib64/libevent-2.0.so.5
```

### xselをインストールする
tmuxからLinuxのクリップボードにコピーするためにxselと連携する。

| OS                       | コマンド                                |
|:-------------------------|:----------------------------------------|
| Debian系([※1](#debian)) | `sudo apt-get install xsel` |
| redhat系 | `sudo yum install xsel`        |

redhat系は試してないのでパッケージ名が違うかも。

## Powerlineをインストールする
tmuxやvimが格好良くなるPowerlineを入れる

### Pythonとpipをインストール
| OS                       | コマンド                                |
|:-------------------------|:----------------------------------------|
| Debian系([※1](#debian)) | `sudo apt-get install python pip` |
| redhat系([※2](#redhat)) | `sudo yum install python python-pip`       |

Python2.6以上でないとダメなので、それよりバージョンが低い場合は手動でビルドしなければならない。
その場合は[ここ](http://qiita.com/a_yasui/items/5f453297855791ed648d)を参照。(TODO 後でちゃんと書く)

### pipでPowerlineをインストール(一番楽な方法)
```sh
pip install --user powerline-status
```

この方法だと一発でインストールできて簡単だが、`$HOME/.local/lib/pythonXXX ...`にインストールされてパスにPythonのバージョンが入る。そうなると、`.tmux.conf`に記述する設定ファイルのパスが環境に依存してしまうことになり面倒なので、下記の方法で回避したほうがいいかも。

### powerlineをGitからcloneしてインストール(環境ごとの違いを無くせる方法)
```sh
cd {repo_root} # {repo_root}はcloneするディレクトリ
git clone https://github.com/powerline/powerline.git
pip install --user --editable={repo_root}/powerline
```

これで設定ファイルのパスは`{repo_root}/powerline/powerline/bindings/tmux/powerline.conf`とすればよいので、環境依存がなくなり複数の環境で使いまわせる。

### psutilモジュールをインストール
powerlineでCPU使用率を表示するのに必要な`psutil`モジュールをインストールする。無くても表示されないだけなので環境次第でどうするか選択する。

```sh
pip install --user psutil
```

powerlineを`--user`で入れたので何となく付けてる。

## Vimをビルド＆インストールする
パッケージマネージャで入れてもいいが、大抵はバージョンが低いので自分でソースからkaoriya版にしてビルドする。

### guiltのインストール
guiltはGitでパッチ管理するコマンドらしい。

```sh
cd {repo_root}
git clone https://github.com/koron/guilt.git
cd guilt
make install
```

### ソースとkaoriyaパッチを取得する
以降、vimのソースやパッチをcloneする場所を`$VIM_SRC_ROOT`とする。

```sh
cd $VIM_SRC_ROOT
git clone https://github.com/vim/vim.git
git clone https://github.com/koron/vim-kaoriya-patches.git
```

### ソースとパッチのバージョンを合わせる
多少ずれてても成功することはあるけど、基本的には合わせたほうがいいので合わせる。

まず [kaoriya-Vimのリポジトリ](https://github.com/koron/vim-kaoriya)を見る。ファイル一覧に下記のように表示されているので、Vim側とパッチ側のリビジョンが分かる。(下記の例は2015/09/26版のkairoya-Vim)
 * patches @ 5fdc61a
 * vim @ ca63501

リビジョンを確認したら各リポジトリでそのリビジョンに合わせる。ついでにブランチも切っておく。

```sh
cd $VIM_SRC_ROOT/vim
git checkout -b kaoriya-7.4.884 ca63501

cd $VIM_SRC_ROOT/vim-kaoriya-patches
git checkout -b 7.4.884 5fdc61a
```

### パッチ適用の準備
guiltでパッチを適用するために少々準備する。

まずVim側のリポジトリで設定を行う。
```sh
cd $VIM_SRC_ROOT/vim
git config guilt.patchesdir ../vim-kaoriya-patches
```

ここで`guilt init`すると、パッチ側に`$VIM_SRC_ROOT/vim-kaoriya-patches/kaoriya-7.4.844`というディレクトリが作られる。しかしその中身は空なので、パッチファイル一式をコピーするという手順をとることになる。それは何となくスマートじゃないように思えるので、シンボリックリンクを作ることで`guilt init`やファイルコピーをせずにパッチを当てる。

```sh
cd $VIM_SRC_ROOT/vim-kaoriya-patches
ln -s master kaoriya-7.4.844  # ここはVim側のブランチ名に合わせる
```

### パッチ適用
```sh
cd $VIM_SRC_ROOT/vim
guilt push -a
```

### 必要なライブラリなどをインストール
ビルドツールはインストール済みとして、他に必要なパッケージをインストールする。ビルドの際のオプションと関係するので適宜変更すること。特に、GVimを作るかどうかでも変わってくるため注意。

#### Debian系([※1](#debian))
```sh
sudo apt-get install \
  gettext \
  libncursed5-dev \
  xorg-dev \
  libgtk2.0-dev \
  liblua5.1 \
  luajit \
  libluajit-5.1-dev \
  python-dev \
  ruby \
  ruby-dev
```

#### redhat系([※2](#redhat))
```sh
sudo yum install \
  gettext \
  ncurses-devel \
  lua-devel \
  python-devel \
  ruby \
  ruby-devel
```

yumにはluajitが無いので、使いたい場合はソースからビルドする必要がある。

```sh
cd {repo_root}
git clone http://luajit.org/git/luajit-2.0.git
cd luajit-2.0
make clean
make
make install
```

これでインストール自体は完了するが、環境によってはVimのビルドの際にエラーになる。その場合、下記の方法でライブラリをパスに追加してやる。

```sh
sudo echo "/usr/local/lib/" > /etc/ld.so.conf.d/luajit.conf
sudo ldconfig
```
(他にはconfigureする際にLIBSで指定してやる方法もあるようだが、よく分からない)

### configure/make
```sh
cd $VIM_SRC_ROOT/vim/src
make autoconf
cd ../
./configure \
  --with-features=huge \
  --disable-selinux \
  --enable-gui=auto \
  --enable-multibyte \
  --enable-pythoninterp \
  --enable-rubyinterp \
  --enable-luainterp \
  --with-lua-prefix=/usr \
  --with-luajit \
  --enable-fontset \
  --enable-fail-if-missing
```
`install/conf.sh`を実行すれば上記と同じことをする。ただし`$VIM_SRC_ROOT`は`$HOME/vim_src`となっている。

これだとインストール先が`/usr/local`になる。変更したければ下記のオプションを追加する。また、GVim関係のオプションも適宜修正する。

|オプション|意味|備考|
|----------|----|----|
|--prefix|Vimのファイルをインストールするディレクトリ|デフォルトは `/usr/local`|
|--exec-prefix|Vimの実行ファイル(vimやvimdiffなど)をインストールするディレクトリ|デフォルトは --prefix の値|
|--enable-gui|GVimを生成する場合に指定する|指定できるのは auto/no/gtk2/gnome2/motif/athena/neXtaw/photon/carbon。デフォルトはauto。Xが入ってなければautoで作られないと思うが、作らないことを明示的に示すならnoを指定する。|

あとは
```sh
make
sudo make install
```

### Kaoriya-Vimのファイルをコピーする
Kaoriya-VimのWindows用アーカイブをダウンロードしてきて、必要なファイルをコピーする。

`/usr/local`にVimをインストールした場合は下記のようになる。パスを変更した場合は適宜変更すること。
また、現時点ではKaoriya-Vimは7.4系なので`vim74-kaoriya-win32`となっているが、7.5系になったら変わるはずなのでその部分にも注意。
```sh
cd /tmp
wget -O vim-kaoriya.zip http://files.kaoriya.net/goto/vim74w32
unzip vim-kaoriya.zip
sudo mv /usr/local/share/vim/vim74 /usr/local/share/vim/vim74.bak
sudo mv \
  vim74-kaoriya-win32/switches \
  vim74-kaoriya-win32/origdoc \
  vim74-kaoriya-win32/vim74 \
  vim74-kaoriya-win32/plugins \
  vim74-kaoriya-win32/gvimrc \
  vim74-kaoriya-win32/vimrc \
  /usr/local/share/vim/
sudo ln -s /usr/local/share/vim/switches/catalog/utf-8.vim /usr/local/share/vim/switches/enabled/utf-8.vim
```

### neobundleとvimprocをインストール
あらかじめ、この2つのプラグインだけは手動でインストールしておく。vimprocはコンパイルもする。

neobundleはシェルスクリプトを実行することでインストールできる。vimprocはcloneした後でコンパイルする。
```sh
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
cd $HOME/.vim/bundle
git clone https://github.com/Shougo/vimproc.vim.git
cd vimproc.vim
make
```

あとはVimを起動すれば他のプラグインがインストールされる。念のためインストール完了後に一度再起動しておく。

* * *

<dl>
  <dt><a name="debian">※1</a></dt>
  <dd>Linux Mint 17.1 (32bit)で確認</dd>

  <dt><a name="redhat">※2</a></dt>
  <dd>CentOS6 (64bit)で確認</dd>

  <dt><a name="warn1">※注意1</a></dt>
  <dd>初回実行時に普通に`rcup -v`だけやると、~/.dotfiles/rcrcみたいなファイルが勝手に作られてしまううえに、それへのシンボリックリンクが~/.rcrcとして作られる。面倒。</dd>

  <dt><a name="warn2">※注意2</a></dt>
  <dd>~/.rcrcもgithub管理下に置いている場合(このリポジトリがそうだけど)、`rcdn`でドットファイルをアンインストールすると~/.rcrcも削除されるので、初回実行時と同じ状態になる。なので、もう1度ドットファイルをインストールしたい場合、`rcup -v`ではなく`env RCRC=… rcup -v`の方で実行しなければならない。</dd>
</dl>

vim:set ts=8 sts=2 sw=2 tw=0 wrap expandtab:
