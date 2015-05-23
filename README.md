# Unix Settings
Unix(主にLinux Mint/CentOS)で使用する dotfiles を管理する。
Vimをソースからビルドするスクリプトもある。

## まずやること
gitをインストールする。
### パッケージマネージャでインストールする
yumやapt-getでインストールする。バージョンが古い可能性が高いが、楽です。

| OS                       | コマンド                     |
|:-------------------------|:-----------------------------|
| Debian系([※1](#debian)) | ``sudo apt-get install git`` |
| redhat系([※2](#redhat)) | ``sudo yum install git``     |

### ソースをビルドする
新しいバージョンを使える。

まずgccなどのビルドツールを導入。Ubuntuとかの build-essential を使うのが楽です。

| OS                       | コマンド                                 |
|:-------------------------|:-----------------------------------------|
| Debian系([※1](#debian)) | ``sudo apt-get install build-essential`` |
| redhat系([※2](#redhat)) | ``sudo yum install "Development Tools"`` |

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
./configure --prefix=~/opt ;# ここでインストール先を指定する
make
make install ;# ~/opt なら sudo は不要なはず。必要に応じて sudo する。
```

※1:<a name="debian">Ubuntu/Linux Mintで確認</a>

※2:<a name="redhat">CentOS6で確認</a>
