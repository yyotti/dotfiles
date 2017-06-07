#!/usr/bin/env bash

function on-error()
{
  local _status=$?
  local _script=$0
  local _line=$1
  shift

  local _args=
  for _i in "$@"; do
    _args+="\"$_i\" "
  done

  cat <<_EOM_ >&2

--------------------------------------------------
Error occured on $_script [Line $_line]: Status $_status

Status: $_status
Commandline: $_script $_args
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

echo

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
zsh_path=$(which zsh)
if ! grep -q "$zsh_path" </etc/shells; then
  echo "$zsh_path" | sudo tee -a /etc/shells
fi
chsh -s "$zsh_path"

echo

#=============================================================================
# Install dotfiles
#
echo 'Install dotfiles.'
git clone https://github.com/yyotti/dotfiles.git "$HOME/.dotfiles"
cd "$HOME/.dotfiles"
git remote set-url origin git@github.com:yyotti/dotfiles.git
cd "$HOME"
RCRC="$HOME/.dotfiles/rcrc" rcup -v

echo

#=============================================================================
# Install Golang
#
echo 'Install Golang.'
go_ver=$( \
  curl -sL https://api.github.com/repos/golang/go/branches \
  | jq -r '.[]|select(.name|startswith("release-branch.go")).name' \
  | sort -r \
  | head -n 1 \
  | sed 's/release-branch\.//' \
  )
if [[ $go_ver != "" ]]; then
  archi=$(uname -sm)
  case "$archi" in
    Linux\ *64) archive_name="$go_ver.linux-amd64.tar.gz" ;;
    Linux\ *86) archive_name="$go_ver.linux-386.tar.gz" ;;
    *) echo "Unknown OS: $archi"; exit 1 ;;
  esac
  cd /tmp
  curl -sLO "https://storage.googleapis.com/golang/$archive_name"
  sudo tar -C /usr/local -xzf "$archive_name"
  export PATH="$GOPATH/bin:/usr/local/go/bin:$PATH"

  # TODO glide
  # go get -u github.com/kr/godep
fi
echo

#=============================================================================
# Install GHQ
#
echo 'Install GHQ.'
go get -u github.com/motemen/ghq
GHQ_ROOT="$HOME/.ghq"

echo

#=============================================================================
# Install FuzzyFinder
#
echo 'Install Fuzzy Finder.'
go get -u github.com/junegunn/fzf/src/fzf
ln -s "$GOPATH/src/github.com/junegunn/fzf/bin/fzf-tmux" "$GOPATH/bin/fzf-tmux"

echo

#=============================================================================
# Install Vim
#
echo 'Install Vim.'
repo=vim/vim
ghq get $repo
cd "$GHQ_ROOT/github.com/$repo"
ver=$(git tag | tail -n 1)
git checkout -b "v$ver" "$ver"
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

echo

#=============================================================================
# Install neovim
#
echo 'Install Neovim.'
repo=neovim/neovim
ghq get $repo
cd "$GHQ_ROOT/github.com/$repo"
ver=$(git tag | tail -n 1)
git checkout -b "v$ver" "$ver"
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

echo

#=============================================================================
# Install neovim-python
#
echo 'Install neovim-python'
sudo pip3 install neovim

echo

#=============================================================================
# Install tmux
#
echo 'Install tmux.'
repo=tmux/tmux
ghq get $repo
cd "$GHQ_ROOT/github.com/$repo"
ver=$(git tag | tail -n 1)
git checkout -b "v$ver" "$ver"
sh autogen.sh
./configure
make
sudo make install
sudo update-alternatives --install /usr/bin/tmux tmux /usr/local/bin/tmux 50

echo

#=============================================================================
# Install tig
#
echo 'Install tig.'
repo=jonas/tig
ghq get $repo
cd "$GHQ_ROOT/github.com/$repo"
ver=$(git tag | tail -n 1)
git checkout -b "v$ver" "$ver"
./autogen.sh
./configure
make prefix=/usr/local
sudo make install prefix=/usr/local

echo

#=============================================================================
# Install Powerline
#
echo 'Install Powerline.'
sudo pip3 install powerline-status

echo

#=============================================================================
# Install Ripgrep
#
# echo 'Install Ripgrep.'
# archi=$(uname -sm)
# case "$archi" in
#   Linux\ *64) archi=x86_64 ;;
#   Linux\ *86) archi=i686 ;;
#   *) echo "Unknown OS: $archi"; exit 1 ;;
# esac
# ripgrep_download_url=$( \
#   curl -sL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest \
#   | jq -r '.assets|.[]|select(.browser_download_url|contains("linux") and contains("'$archi'")).browser_download_url' \
#   )
# if [[ $ripgrep_download_url != "" ]]; then
#   archive_name=$(basename "$ripgrep_download_url")
#   dir=$(basename "$archive_name" .tar.gz)
#   cd /tmp
#   curl -sLO "$ripgrep_download_url"
#   mkdir -p "$HOME/opt"
#   rm -fr "$HOME/opt/ripgrep"
#   tar -xzf "$archive_name"
#   mv "$dir" "$HOME/opt/ripgrep"
#   mkdir -p "$HOME/bin"
#   ln -s "$HOME/opt/ripgrep/rg" "$HOME/bin/rg"
# fi
#
# echo

#=============================================================================
# Install The Platinum Searcher
#
echo 'Install The Platinum Searcher.'
go get -u github.com/monochromegane/the_platinum_searcher/cmd/pt

echo

#=============================================================================
# Install golint
#
echo 'Install golint.'
go get -u github.com/golang/lint/golint

echo

#=============================================================================
# Install vimlparser (Golang version)
#
echo 'Install vimlparser(Golang version).'
go get -u github.com/haya14busa/go-vimlparser/cmd/vimlparser

#=============================================================================
# Install git-now
#
echo 'Install git-now.'
repo=iwata/git-now
ghq get $repo
cd "$GHQ_ROOT/github.com/$repo"
find . -type d -name '.git' -prune -o -type d -exec chmod 755 {} \;
git submodule init
git submodule update
sudo make install

#=============================================================================
# Install Lemonade
#
echo 'Install Lemonade.'
go get -u github.com/pocke/lemonade

echo "Setup finished."

# vim:set sw=2:
