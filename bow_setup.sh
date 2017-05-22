#!/usr/bin/env bash

# TODO スクリプト内変数の命名を直す

function on-error()
{
  local status=$?
  local script=$0
  local line=$1
  shift

  local args=
  for i in "$@"; do
    args+="\"$i\" "
  done

  cat <<_EOM_ >&2

--------------------------------------------------
Error occured on $script [Line $line]: Status $status

Status: $status
Commandline: $script $args
--------------------------------------------------

_EOM_
}

set -eu
trap 'on-error $LINENO "$@"' ERR

export GOPATH="$HOME/.go"
if [[ ! -d $GOPATH ]]; then
  mkdir -p "$GOPATH"
fi

#=============================================================================
# Replace source url
#
sed -e 's%archive.ubuntu.com%ubuntutym.u-toyama.ac.jp%g' </etc/apt/sources.list \
  | tee >(sed -e 's%deb %deb-src %g') \
  | cat >/tmp/sources.list
if [[ ! -e /etc/apt/sources.list.org ]]; then
  sudo cp /etc/apt/sources.list /etc/apt/sources.list.org
fi
sudo mv -f /tmp/sources.list /etc/apt/sources.list

# TODO 各種インストールを別ファイルに分ける
# ex) apt-install.sh, git-install.sh, etc..

#=============================================================================
# Add PPA
#
# Git
sudo add-apt-repository -y ppa:git-core/ppa
# rcm
sudo add-apt-repository -y ppa:martin-frost/thoughtbot-rcm
# php5.6
sudo add-apt-repository -y ppa:ondrej/php
# fish
sudo add-apt-repository -y ppa:fish-shell/release-2

#=============================================================================
# Update apt packages
#
sudo apt -y update
sudo apt -y upgrade
sudo apt -y autoremove

#=============================================================================
# Install required packages
#
sudo apt -y install \
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
  python3 \
  libpython3-dev \
  python3-pip \
  libevent-2.0-5 \
  libevent-dev \
  cmake \
  libicu-dev \
  rcm \
  php5.6 \
  php5.6-zip \
  php5.6-mbstring \
  php5.6-xml \
  php5.6-gd \
  xsel \
  jq \
  lynx \
  shellcheck \
  skkdic \
  zip

echo ''

#=============================================================================
# Install pip packages
#
sudo pip3 install --upgrade pip
sudo pip3 install \
  psutil \
  flake8 \
  hacking \
  pep8-naming

#=============================================================================
# Change default shell
#
echo 'Change default shell.'
FISH_PATH=$(which fish)
if ! grep -q "$FISH_PATH" </etc/shells; then
  echo "$FISH_PATH" | sudo tee -a /etc/shells
fi
if [[ -f $HOME/.bashrc ]] && ! grep -q 'if \[[ -t 1 \]]; then' <"$HOME/.bashrc"; then
  if [[ ! -f $HOME/.bashrc_org ]]; then
    mv "$HOME/.bashrc" "$HOME/.bashrc_org"
  fi
  echo "if [[ -t 1 ]]; then SHELL=\"$FISH_PATH\" exec \"$FISH_PATH\"; fi" >"$HOME/.bashrc"
fi

echo ''

#=============================================================================
# Install dotfiles
#
echo 'Install dotfiles.'
git clone https://github.com/yyotti/dotfiles.git "$HOME/.dotfiles"
cd "$HOME/.dotfiles"
git remote set-url origin git@github.com:yyotti/dotfiles.git
cd "$HOME"
RCRC="$HOME/.dotfiles/rcrc" rcup -v

echo ''

#=============================================================================
# Install Golang
#
echo 'Install Golang.'
GO_VER=$( \
  curl -sL https://api.github.com/repos/golang/go/branches \
  | jq -r '.[]|select(.name|startswith("release-branch.go")).name' \
  | sort -r \
  | head -n 1 \
  | sed 's/release-branch\.//' \
  )
if [[ $GO_VER != "" ]]; then
  archi=$(uname -sm)
  case "$archi" in
    Linux\ *64) ARCHIVE_NAME="$GO_VER.linux-amd64.tar.gz" ;;
    Linux\ *86) ARCHIVE_NAME="$GO_VER.linux-386.tar.gz" ;;
    *) echo "Unknown OS: $archi"; exit 1 ;;
  esac
  cd /tmp
  curl -sLO "https://storage.googleapis.com/golang/$ARCHIVE_NAME"
  sudo tar -C /usr/local -xzf "$ARCHIVE_NAME"
  export PATH="$GOPATH/bin:/usr/local/go/bin:$PATH"

  go get github.com/kr/godep
fi
echo ''

#=============================================================================
# Install GHQ
#
echo 'Install GHQ.'
go get github.com/motemen/ghq
GHQ_ROOT="$(ghq root)"

echo ''

#=============================================================================
# Install FuzzyFinder
#
echo 'Install Fuzzy Finder.'
REPO=junegunn/fzf
ghq get $REPO
cd "$GHQ_ROOT/github.com/$REPO"
./install --key-bindings --completion --no-update-rc

echo ''

#=============================================================================
# Install Vim
#
echo 'Install Vim.'
REPO=vim/vim
ghq get $REPO
cd "$GHQ_ROOT/github.com/$REPO"
VER=$(git tag | tail -n 1)
git checkout -b "v$VER" "$VER"
cd ./src
make autoconf
cd ../
./configure \
  --with-features=huge \
  --disable-selinux \
  --enable-gui=no \
  --enable-multibyte \
  --enable-python3interp \
  --enable-luainterp \
  --with-lua-prefix=/usr \
  --with-luajit \
  --enable-fontset \
  --enable-fail-if-missing
make
sudo make install
sudo update-alternatives --install /usr/bin/vim vim /usr/local/bin/vim 50

echo ''

#=============================================================================
# Install neovim
#
echo 'Install Neovim.'
REPO=neovim/neovim
ghq get $REPO
cd "$GHQ_ROOT/github.com/$REPO"
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

echo ''

#=============================================================================
# Install neovim-python
#
echo 'Install neovim-python'
sudo pip3 install neovim

echo ''

#=============================================================================
# Install tmux
#
echo 'Install tmux.'
REPO=tmux/tmux
ghq get $REPO
cd "$GHQ_ROOT/github.com/$REPO"
VER=$(git tag | tail -n 1)
git checkout -b "v$VER" "$VER"
sh autogen.sh
./configure
make
sudo make install
sudo update-alternatives --install /usr/bin/tmux tmux /usr/local/bin/tmux 50

echo ''

#=============================================================================
# Install tig
#
echo 'Install tig.'
REPO=jonas/tig
ghq get $REPO
cd "$GHQ_ROOT/github.com/$REPO"
VER=$(git tag | tail -n 1)
git checkout -b "v$VER" "$VER"
./autogen.sh
./configure
make prefix=/usr/local
sudo make install prefix=/usr/local

echo ''

#=============================================================================
# Install Powerline
#
echo 'Install Powerline.'
sudo pip3 install powerline-status

echo ''

#=============================================================================
# Install Ripgrep
#
# TODO Cargoをインストールしてビルドする？
# TODO ↑をやるならghq管理にする
echo 'Install Ripgrep.'
archi=$(uname -sm)
case "$archi" in
  Linux\ *64) ARCHI=x86_64 ;;
  Linux\ *86) ARCHI=i686 ;;
  *) echo "Unknown OS: $archi"; exit 1 ;;
esac
RIPGREP_DOWNLOAD_URL=$( \
  curl -sL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest \
  | jq -r '.assets|.[]|select(.browser_download_url|contains("linux") and contains("'$ARCHI'")).browser_download_url' \
  )
if [[ $RIPGREP_DOWNLOAD_URL != "" ]]; then
  ARCHIVE_NAME=$(basename "$RIPGREP_DOWNLOAD_URL")
  DIRNAME=$(basename "$ARCHIVE_NAME" .tar.gz)
  cd /tmp
  curl -sLO "$RIPGREP_DOWNLOAD_URL"
  mkdir -p "$HOME/opt"
  rm -fr "$HOME/opt/ripgrep"
  tar -xzf "$ARCHIVE_NAME"
  mv "$DIRNAME" "$HOME/opt/ripgrep"
  mkdir -p "$HOME/bin"
  ln -s "$HOME/opt/ripgrep/rg" "$HOME/bin/rg"
fi

echo ''

#=============================================================================
# Install golint
#
# ghqだとインストールまでやってくれないのでgoで取ってくる
echo 'Install golint.'
go get github.com/golang/lint/golint

echo ''

#=============================================================================
# Install vimlparser (Golang version)
#
echo 'Install vimlparser(Golang version).'
go get github.com/haya14busa/go-vimlparser/cmd/vimlparser

#=============================================================================
# Install git-now
#
echo 'Install git-now.'
REPO=iwata/git-now
ghq get $REPO
cd "$GHQ_ROOT/github.com/$REPO"
git submodule init
git submodule update
sudo make install

echo "Setup finished."

# vim:set sw=2:
