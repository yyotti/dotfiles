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

echo -n "Source directory ([/usr/local/src]):"
read SRC_DIR
if test -z "$SRC_DIR"; then
  SRC_DIR=/usr/local/src
fi

sudo sed -i -e "s/127.0.0.1 localhost/127.0.0.1 localhost $(hostname)/g" /etc/hosts

sed -e 's%archive.ubuntu.com%ubuntutym.u-toyama.ac.jp%g' /etc/apt/sources.list > /tmp/sources.list
sed -e 's%deb %deb-src %g' /tmp/sources.list >> /tmp/sources.list
sudo mv -f /etc/apt/sources.list /etc/apt/sources.list.org
sudo mv -f /tmp/sources.list /etc/apt/sources.list

sudo add-apt-repository -y ppa:git-core/ppa
sudo add-apt-repository -y ppa:martin-frost/thoughtbot-rcm
sudo add-apt-repository -y ppa:ondrej/php

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y autoremove

sudo apt-get -y install \
  zsh \
  git \
  build-essential \
  autoconf \
  libncurses5-dev \
  libncursesw5-dev \
  nkf \
  liblua5.1-0-dev \
  luajit \
  libluajit-5.1-dev \
  python3 \
  libpython3-dev \
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
  xsel

chsh -s /bin/zsh

if test ! -e "$SRC_DIR"; then
  sudo mkdir -p "$SRC_DIR"
fi
sudo chmod a+w "$SRC_DIR"

mkdir -p $HOME/git
cd $HOME/git
git clone https://github.com/yyotti/dotfiles.git
cd $HOME
RCRC=$HOME/git/dotfiles/rcrc rcup -v
cd $HOME/git/dotfiles
git remote set-url origin git@github.com:yyotti/dotfiles.git

cd $SRC_DIR
git clone https://github.com/koron/cmigemo.git
cd cmigemo
./configure
make -j2 gcc
make -j2 gcc-dict
sudo make gcc-install
echo /usr/local/lib | sudo tee -a /etc/ld.so.conf
sudo /sbin/ldconfig

cd $SRC_DIR
git clone https://github.com/koron/guilt.git
cd guilt
sudo make install

cd $SRC_DIR
git clone https://github.com/koron/vim-kaoriya.git
cd vim-kaoriya
git submodule init
git submodule update

cd vim
VER=`git log --oneline -n 1 | awk '{{print $3}}'`
git checkout -b $VER
git config guilt.patchesdir $SRC_DIR/vim-kaoriya/patches
cp -rf $SRC_DIR/vim-kaoriya/patches/master $SRC_DIR/vim-kaoriya/patches/$VER
guilt init
guilt push -a

cd src
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

cd $SRC_DIR
git clone https://github.com/tmux/tmux.git
cd tmux
VER=`git tag | tail -n 1`
git checkout -b $VER $VER
sh autogen.sh
./configure
make -j2
sudo make install

cd $SRC_DIR
git clone https://github.com/jonas/tig.git
cd tig
VER=`git tag | tail -n 1`
git checkout -b $VER $VER
./autoge.sh
./configure --without-ncurses
make prefix=/usr/local
sudo make install prefix=/usr/local

OPT_DIR=$HOME/opt
mkdir -p $OPT_DIR
cd $OPT_DIR
git clone https://github.com/powerline/powerline.git

pip3 install --user psutil
pip3 install --user --editable=$OPT_DIR/powerline

sudo update-alternatives --install /usr/bin/vim vim /usr/local/bin/vim 50
sudo update-alternatives --install /usr/bin/tmux tmux /usr/local/bin/tmux 50

RIPGREP=ripgrep-0.4.0-x86_64-unknown-linux-musl
cd /tmp
wget https://github.com/BurntSushi/ripgrep/releases/download/0.4.0/$RIPGREP.tar.gz
tar xzf $RIPGREP.tar.gz
mv $RIPGREP $OPT_DIR/ripgrep

echo "Setup finished."
read a
