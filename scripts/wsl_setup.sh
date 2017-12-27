#!/usr/bin/env bash

set -eu

# For error {{{
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
# }}}

sudopw=

function mysudo()
{
  echo "${sudopw}" | sudo -p '' -S "$@"
}

# Initialize for `sudo` {{{
read -s -p "Input root password (for \`sudo\`): " sudopw
echo
if [[ -z $sudopw ]]; then
  exit 0
fi

trap 'sudo -k' EXIT
sudo -k
echo -n 'Checking password... '
set +e
mysudo echo 'valid' 2>/dev/null
if [[ $? != 0 ]]; then
  echo 'invalid'
  exit 1
fi
set -e
# }}}

trap 'on-error $LINENO "$@"' ERR

# XDG Base Directory
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

export GOPATH=$XDG_DATA_HOME/go
if [[ ! -d $GOPATH ]]; then
  mkdir -p "$GOPATH"
fi

#=============================================================================
# Replace source url
#
apt_src=/etc/apt/sources.list
tmp_src=$(mktemp)
sed -e 's%archive.ubuntu.com%ubuntutym.u-toyama.ac.jp%g' <"$apt_src" \
  | tee >(sed -e 's%deb %deb-src %g') \
  | cat >"$tmp_src"
if [[ ! -e ${apt_src}.org ]]; then
  mysudo cp "$apt_src" "${apt_src}.org"
fi
mysudo mv -f "$tmp_src" "$apt_src"

# TODO 各種インストールを別ファイルに分ける
# ex) apt-install.sh, git-install.sh, etc..

#=============================================================================
# Add PPA
#
# Git
mysudo add-apt-repository -y ppa:git-core/ppa
# php5.6
mysudo add-apt-repository -y ppa:ondrej/php

#=============================================================================
# Update apt packages
#
mysudo apt -y update
mysudo apt -y upgrade
mysudo apt -y autoremove

#=============================================================================
# Install required packages
#
mysudo apt -y install \
  autoconf \
  build-essential \
  cmake \
  git \
  jq \
  language-pack-ja \
  libevent-2.0-5 \
  libevent-dev \
  libicu-dev \
  liblua5.1-0-dev \
  libluajit-5.1-dev \
  libncurses5-dev \
  libncursesw5-dev \
  libpython3-dev \
  luajit \
  lynx \
  manpages-ja \
  nkf \
  php5.6 \
  php5.6-gd \
  php5.6-mbstring \
  php5.6-xml \
  php5.6-zip \
  python3 \
  python3-pip \
  shellcheck \
  skkdic \
  xsel \
  zip \
  zsh

echo

#=============================================================================
# Install pip packages
#
mysudo pip3 install --upgrade pip
mysudo pip3 install \
  psutil \
  flake8 \
  hacking \
  pep8-naming

#=============================================================================
# Add zsh path
#
echo 'Add zsh path to /etc/shells'
zsh_path=$(which zsh)
if ! grep -q "$zsh_path" </etc/shells; then
  mysudo "$(which bash)" -c "echo $zsh_path >>/etc/shells"
fi

echo

#=============================================================================
# Install dotfiles
#
echo 'Install dotfiles.'
_dothome=$XDG_DATA_HOME/dotfiles
git clone https://github.com/yyotti/dotfiles.git "$_dothome"
"$_dothome/scripts/dotinstall.sh" -v install
find "$_dothome/scripts/git" -type d -exec chmod 755 {} \;

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
if [[ $go_ver != '' ]]; then
  archi=$(uname -sm)
  case "$archi" in
    Linux\ *64) archive_name=$go_ver.linux-amd64.tar.gz ;;
    Linux\ *86) archive_name=$go_ver.linux-386.tar.gz ;;
    *) echo "Unknown OS: $archi"; exit 1 ;;
  esac
  cd /tmp
  curl -sLO "https://storage.googleapis.com/golang/$archive_name"
  mysudo tar -C /usr/local -xzf "$archive_name"
  export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

  echo 'Install Dep.'
  go get -v -u github.com/golang/dep/cmd/dep
fi

echo

#=============================================================================
# Install GHQ
#
echo 'Install GHQ.'
go get -v -u github.com/motemen/ghq
find "$GOPATH/src/github.com/motemen/ghq" -type d -name '.git' -prune \
  -o -type d -exec chmod 755 {} \;
GHQ_ROOT=$XDG_DATA_HOME/ghq

echo

#=============================================================================
# Install FuzzyFinder
#
echo 'Install Fuzzy Finder.'
go get -v -u github.com/junegunn/fzf
ln -s "$GOPATH/src/github.com/junegunn/fzf/bin/fzf-tmux" "$GOPATH/bin/fzf-tmux"

echo

#=============================================================================
# Install Vim
#
# echo 'Install Vim.'
# repo=vim/vim
# ghq get $repo
# cd "$GHQ_ROOT/github.com/$repo"
# ver=$(git tag | tail -n 1)
# git checkout -b "v$ver" "$ver"
# cd ./src
# make autoconf
# cd ../
# ./configure \
#   --with-features=huge \
#   --disable-selinux \
#   --enable-gui=no \
#   --enable-multibyte \
#   --enable-python3interp \
#   --enable-luainterp \
#   --with-lua-prefix=/usr \
#   --with-luajit \
#   --enable-fontset \
#   --enable-fail-if-missing
# make
# mysudo make install
# mysudo update-alternatives --install /usr/bin/vim vim /usr/local/bin/vim 50
#
# echo

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
mysudo make install
mysudo update-alternatives --install /usr/bin/vim vim /usr/local/bin/nvim 50

echo

#=============================================================================
# Install neovim-python
#
echo 'Install neovim-python'
mysudo pip3 install neovim

echo

#=============================================================================
# Install wcwidth
#
echo 'Install wcwidth.'
repo=fumiyas/wcwidth-cjk
ghq get $repo
cd "$GHQ_ROOT/github.com/$repo"
ver=$(date +'%Y%m%d')
git checkout -b "v$ver" master
autoreconf --install
./configure --prefix=/usr/local/
make
mysudo make install

echo

#=============================================================================
# Install tmux
#
# https://gist.github.com/z80oolong/e65baf0d590f62fab8f4f7c358cbcc34
#
echo 'Install tmux.'
repo=tmux/tmux
ghq get $repo
cd "$GHQ_ROOT/github.com/$repo"
ver='2.6'
git checkout -b "v$ver" "$ver"
git apply --verbose --binary <(curl -sL https://gist.githubusercontent.com/z80oolong/e65baf0d590f62fab8f4f7c358cbcc34/raw/79816afd71715ed409c5a81097456c822e5e2cfc/tmux-HEAD-fb02df66-fix.diff)
sh autogen.sh
./configure
make
mysudo make install
mysudo update-alternatives --install /usr/bin/tmux tmux /usr/local/bin/tmux 50

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
mysudo make install prefix=/usr/local

echo

#=============================================================================
# Install Powerline
#
echo 'Install Powerline.'
mysudo pip3 install powerline-status

echo

#=============================================================================
# Install The Platinum Searcher
#
echo 'Install The Platinum Searcher.'
go get -v -u github.com/monochromegane/the_platinum_searcher/cmd/pt

echo

#=============================================================================
# Install golint
#
echo 'Install golint.'
go get -v -u github.com/golang/lint/golint

echo

#=============================================================================
# Install vimlparser (Golang version)
#
echo 'Install vimlparser(Golang version).'
go get -v -u github.com/haya14busa/go-vimlparser/cmd/vimlparser

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
mysudo make install

#=============================================================================
# Install Lemonade
#
echo 'Install Lemonade.'
go get -v -u github.com/pocke/lemonade

echo

#=============================================================================
# Install gist
#
echo 'Install gist.'
go get -v -u github.com/b4b4r07/gist
cd "$GHQ_ROOT/github.com/$repo"
find "$GOPATH/src/github.com/b4b4r07/gist/misc/completion" \
  -type d -name '.git' -prune -o -type d -exec chmod 755 {} \;

echo

#=============================================================================
# Change shell
#
echo "Change shell ($(which zsh))."
chsh -s "$(which zsh)"

echo "Setup finished."
echo "Rem: Configure gist! (run \`gist config\`)"

# vim:set sw=2:
