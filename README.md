# Linux環境構築メモ
Linux(主にLinux Mint/CentOS)で自分の環境を作るためのメモ。

## ログインシェルをzshに変更する
Linux MintもCentOSも、デフォルトだとbashなので、パッケージマネージャでzshをインストールする。

| OS                       | コマンド                   |
|:-------------------------|:---------------------------|
| Debian系([※1](#debian)) | `sudo apt-get install zsh` |
| redhat系([※2](#redhat)) | `sudo yum install zsh`     |

インストールできたら、ログインシェルを変更する。zshのパスは環境により異なるようなので、
```sh
cat /etc/shells
```
で確認して
```sh
chsh -s /usr/bin/zsh
```
とかする。

変更後にログインしなおしてzshになっていることを確認。

## ビルドツールをインストール
gccなどのビルドツールを導入。Ubuntuとかの build-essential を使うのが楽。

| OS                       | コマンド                                    |
|:-------------------------|:--------------------------------------------|
| Debian系([※1](#debian)) | `sudo apt-get install build-essential`      |
| redhat系([※2](#redhat)) | `sudo yum groupinstall "Development Tools"` |

## gitをインストール

#### パッケージマネージャでインストールする
バージョンが古い可能性が高いが、楽。

| OS                       | コマンド                   |
|:-------------------------|:---------------------------|
| Debian系([※1](#debian)) | `sudo apt-get install git` |
| redhat系([※2](#redhat)) | `sudo yum install git`     |

#### ソースをビルドする
新しいバージョンを使える。

まず、必要なライブラリをインストールする。

#### Debian系([※1](#debian))
apt-getでインストールする。

```sh
# TODO
```

#### redhat系([※2](#redhat))
yumでインストールする。

```sh
sudo yum install \
  curl-devel \
  expat-devel \
  gettext-devel \
  openssl-devel \
  zlib-devel \
  perl-ExtUtils-MakeMaker
```

その後、以下のコマンドを叩く。

```sh
cd /tmp
wget https://github.com/git/git/archive/master.zip
unzip master.zip
cd git-master
make prefix=/usr/local
sudo make prefix=/usr/local install
```
デフォルトでは/usrにインストールされる（？）ようだったが、何となく嫌だったので/usr/localへ。

## rcmをインストールする
ドットファイル管理ツール [rcm](https://github.com/thoughtbot/rcm) をインストールする。デフォルトのリポジトリには無いので、リポジトリの追加が必要になる。

#### Debian系([※1](#debian))
apt-getでインストールする。

```sh
sudo add-apt-repository ppa:martin-frost/thoughtbot-rcm
sudo apt-get update
sudo apt-get install rcm
```

#### redhat系([※2](#redhat))
yumでインストールする。

```sh
cd /etc/yum.repos.d/
sudo wget http://download.opensuse.org/repositories/utilities/CentOS_6/utilities.repo
sudo yum install rcm
```

## ドットファイルをインストールする
まず、このリポジトリをcloneする。
```sh
mkdir -p ~/git
cd ~/git
git clone git@github.com:yyotti/unix_settings.git
```
rcupの初回実行時は、~/.rcrcがないはずなので設定ファイルを指定したうえで実行する([※注意1](#warn1)を参照)。
```sh
env RCRC=$HOME/git/unix_settings/rcrc rcup -v ;# $HOME/git/… ではなく ~/git/… だとうまく実行できなかった気がする
```
`-v`をつけると、どのファイルをどうしたか表示されて何となく安心する。

2回目以降の実行は
```sh
rcup -v
```
だけでOK。([※注意2](#warn2)を参照)

インストールが完了したら、設定を反映するため`source ~/.zshrc`したりターミナルを再起動したりする。`source`する場合、zshenvも忘れずに。

## tmuxをインストール

#### パッケージマネージャでインストールする
バージョンが古い可能性が高いが、楽。

| OS                       | コマンド                    |
|:-------------------------|:----------------------------|
| Debian系([※1](#debian)) | `sudo apt-get install tmux` |
| redhat系([※2](#redhat)) | リポジトリにない            |

#### ソースをビルドする
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

## xselをインストールする
tmuxからLinuxのクリップボードにコピーするためにxselと連携する。

| OS                       | コマンド                                |
|:-------------------------|:----------------------------------------|
| Debian系([※1](#debian)) | `sudo apt-get install xsel` |
| redhat系 | `sudo yum install xsel`        |

redhat系は試してないのでパッケージ名が違うかも。

## Powerlineをインストールする
tmuxやzshが格好良くなるPowerlineを入れる

### Pythonとpipをインストール
| OS                       | コマンド                                |
|:-------------------------|:----------------------------------------|
| Debian系([※1](#debian)) | `sudo apt-get install python pip` |
| redhat系 | `sudo yum install python python-pip`       |

### pipでPowerlineをインストール
```sh
pip install --user powerline-status
```

### 設定ディレクトリへのシンボリックリンクを作る
環境によって`~/.local/lib/pythonXXX/site-packages/powerline/bindings/tmux/powerline.conf`のXXXの部分が違ってくるので、それを吸収するためにシンボリックリンクで対応する。

```sh
ln -s ~/.local/lib/python2.7 ~/.local/lib/python
```

## Vimをビルド＆インストールする
このリポジトリ内のインストールスクリプトを実行する。
```sh
cd /path/to/unix_settings
./install/viminstall.sh
```

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
