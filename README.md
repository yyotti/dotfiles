# Unix Settings
Unix(主にLinux Mint/CentOS)で使用する dotfiles を管理する。
Vimをソースからビルドするスクリプトもある。

## まずやること

### ログインシェルをzshに変更する
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

### gitをインストールする。

#### パッケージマネージャでインストールする
バージョンが古い可能性が高いが、楽。

| OS                       | コマンド                   |
|:-------------------------|:---------------------------|
| Debian系([※1](#debian)) | `sudo apt-get install git` |
| redhat系([※2](#redhat)) | `sudo yum install git`     |

#### ソースをビルドする
新しいバージョンを使える。

まずgccなどのビルドツールを導入。Ubuntuとかの build-essential を使うのが楽です。

| OS                       | コマンド                               |
|:-------------------------|:---------------------------------------|
| Debian系([※1](#debian)) | `sudo apt-get install build-essential` |
| redhat系([※2](#redhat)) | `sudo yum install "Development Tools"` |

その後、以下のコマンドを叩く。

```sh
cd /tmp
wget https://github.com/git/git/archive/master.zip
unzip master.zip
cd git-master
make
sudo make install
```

root権限がなかったり、デフォルトの場所(/usr/local)以外にインストールしたい場合は以下のようにする。(INSTALL に書いてあった)
```sh
# unzip までは上と同じ
cd git-master
make configure
./configure --prefix=$HOME/opt ;# ここでインストール先を指定する
make
make install ;# $HOME/opt なら sudo は不要なはず。必要に応じて sudo する。
```

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

## TODO 続きを書く

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
