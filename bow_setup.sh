#!/bin/sh

echo -n "Alternative home directory ([$HOME]):"
read HOME_PATH
if test -n "$HOME_PATH" -a "$HOME" != "$HOME_PATH"; then
  if test -d "$HOME_PATH" -a -r "$HOME_PATH"; then
    if test ! -e /etc/passwd.org; then
      sudo cp /etc/passwd /etc/passwd.org
    fi

    sudo sed -i -e "s%/home/$USER%/mnt/d/home/$USER%g" /etc/passwd
  else
    echo "Invalid path."
    exit
  fi

  echo -n 'Copy dotfiles? [y/N]:'
  read COPY
  if test "$COPY" = "y" -o "$COPY" = "Y"; then
    cp $HOME/.* $HOME_PATH/
  fi

  HOME=$HOME_PATH
  export HOME
fi

echo -n "Golang home directory ([$HOME/.go]):"
read GOPATH
if test -z "$GOPATH"; then
  GOPATH=$HOME/.go
fi

echo -n "GHQ_ROOT directory ([$GOPATH/src]):"
read GHQ_ROOT
if test -z "$GHQ_ROOT"; then
  GHQ_ROOT=$GOPATH/src
fi

echo $GHQ_ROOT

sudo sed -i -e "s/127.0.0.1 localhost/127.0.0.1 localhost $(hostname)/g" /etc/hosts

sed -e 's%archive.ubuntu.com%ubuntutym.u-toyama.ac.jp%g' /etc/apt/sources.list > /tmp/sources.list
sed -e 's%deb %deb-src %g' /tmp/sources.list >> /tmp/sources.list
sudo mv -f /etc/apt/sources.list /etc/apt/sources.list.org
sudo mv -f /tmp/sources.list /etc/apt/sources.list

# TODO 各種インストールを別ファイルに分ける
# ex) apt-get-install.sh, git-install.sh, etc..

# Git
sudo add-apt-repository -y ppa:git-core/ppa
# rcm
sudo add-apt-repository -y ppa:martin-frost/thoughtbot-rcm
# php5.6
sudo add-apt-repository -y ppa:ondrej/php
# fish
sudo add-apt-repository -y ppa:fish-shell/release-2
# go
sudo add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
# python3.5
sudo add-apt-repository -y ppa:fkrull/deadsnakes

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y autoremove

sudo apt-get -y install \
  zsh \
  fish \
  git \
  build-essential \
  autoconf \
  libncurses5-dev \
  libncursesw5-dev \
  nkf \
  liblua5.1-0-dev \
  luajit \
  libluajit-5.1-dev \
  python3.5 \
  libpython3.5-dev \
  python3-pip \
  libevent-2.0-5 \
  libevent-dev \
  libboost-all-dev \
  cmake \
  libicu-dev \
  rcm \
  php5.6 \
  php5.6-zip \
  php5.6-mbstring \
  php5.6-xml \
  xsel \
  golang

FISH_PATH=`which fish`
if [ -z `cat /etc/shells | grep "$FISH_PATH"` ]; then
  echo $FISH_PATH | sudo tee -a /etc/shells
fi
# chsh -s /bin/zsh
chsh -s $FISH_PATH

# ghq
go get github.com/motemen/ghq
PATH=$GOPATH/bin:$PATH

# fzf
REPO=junegunn/fzf
ghq get $REPO
cd $GHQ_ROOT/github.com/$REPO
./install --key-bindings --completion --no-update-rc

# dotfiles
REPO=yyotti/dotfiles
ghq get $REPO
cd $GHQ_ROOT/github.com/$REPO
git remote set-url origin git@github.com:yyotti/dotfiles.git
cd $HOME
RCRC=$GHQ_ROOT/$REPO/rcrc rcup -v

# cmigemo
REPO=koron/cmigemo
ghq get $REPO
cd $GHQ_ROOT/github.com/$REPO
./configure
make -j2 gcc
make -j2 gcc-dict
sudo make gcc-install
echo /usr/local/lib | sudo tee -a /etc/ld.so.conf
sudo /sbin/ldconfig

# guilt
REPO=koron/guilt
ghq get $REPO
cd $GHQ_ROOT/github.com/$REPO
sudo make install

# vim-kaoriya
REPO=koron/vim-kaoriya
ghq get $REPO
cd $GHQ_ROOT/github.com/$REPO
# TODO ↓必要か調査
# git submodule init
# git submodule update
cd ./vim
VER=`git log --oneline -n 1 | awk '{{print $3}}'`
git checkout -b v$VER
git config guilt.patchesdir $GHQ_ROOT/vim-kaoriya/patches
cp -rf $GHQ_ROOT/vim-kaoriya/patches/master $GHQ_ROOT/vim-kaoriya/patches/$VER
guilt init
guilt push -a
cd ./src
make autoconf
cd ../
LIBS="-lmigemo" ./configure \
  --with-features=huge \
  --disable-selinux \
  --enable-gui=no \
  --enable-multibyte \
  --enable-python3interp \
  --enable-luainterp \
  --with-lua-prefix=/usr \
  --with-luajit \
  --enable-fontset \
  --enable-migemo \
  --enable-fail-if-missing
make -j2
sudo make install

# tmux
REPO=tmux/tmux
ghq get $REPO
cd $GHQ_ROOT/github.com/$REPO
VER=`git tag | tail -n 1`
git checkout -b v$VER $VER
sh autogen.sh
./configure
make -j2
sudo make install

# tig
REPO=jonas/tig
ghq get $REPO
cd $GHQ_ROOT/github.com/$REPO
VER=`git tag | tail -n 1`
git checkout -b v$VER $VER
./autoge.sh
./configure --without-ncurses
make prefix=/usr/local
sudo make install prefix=/usr/local

# powerline
REPO=powerline/powerline
ghq get $REPO
cd $GHQ_ROOT/github.com/$REPO
pip3 install --user psutil
pip3 install --user --editable=$GHQ_ROOT/github.com/$REPO

# ripgrep
# TODO Cargoをインストールしてビルドする？
# TODO ↑をやるならghq管理にする
RIPGREP=ripgrep-0.4.0-x86_64-unknown-linux-musl
cd /tmp
wget https://github.com/BurntSushi/ripgrep/releases/download/0.4.0/$RIPGREP.tar.gz
tar xzf $RIPGREP.tar.gz
mkdir -p $HOME/opt
mv $RIPGREP $HOME/opt/ripgrep

sudo update-alternatives --install /usr/bin/vim vim /usr/local/bin/vim 50
sudo update-alternatives --install /usr/bin/tmux tmux /usr/local/bin/tmux 50
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5 50

echo "Setup finished."
read a
