#!/usr/bin/env bash

set -eu

umask 022

echo 'Initialize for sudo' # {{{
sudo -k
trap 'sudo -k' EXIT
echo # }}}

echo 'Set  Environment variables' # {{{
# XDG Base Directory
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-${HOME}/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-${HOME}/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-${HOME}/.local/share}

# Golang
export GOPATH=${GOPATH:-${XDG_DATA_HOME}/go}
export PATH="${GOPATH}/bin:${PATH}"

# Dotfiles
export DOTFILES=${DOTFILES:-${XDG_DATA_HOME}/dotfiles}
echo # }}}

echo 'Create ~/.bin' # {{{
if [[ ! -d ${HOME}/.bin ]]; then
  mkdir -p "${HOME}/.bin"
fi
echo # }}}

echo 'Update pre-installed packages' # {{{
# Replace source url
apt_src=/etc/apt/sources.list
if [[ ! -e ${apt_src}.org ]]; then
  tmp_src=$(mktemp)
  sed -e 's%archive.ubuntu.com%ubuntutym.u-toyama.ac.jp%g' <"${apt_src}" \
    | tee >(sed -e 's%deb %deb-src %g') \
    | cat >"${tmp_src}"
  sudo cp "${apt_src}" "${apt_src}.org"
  sudo mv -f "${tmp_src}" "${apt_src}"
fi

# Update packages
sudo apt -y update
sudo apt -y upgrade
sudo apt -y autoremove

echo # }}}

echo 'Install Japanese languages' # {{{
sudo apt -y install \
  language-pack-ja \
  manpages-ja \
  skkdic
echo # }}}

echo 'Install Linuxbrew (http://linuxbrew.sh/)' # {{{
if [[ ! -x /home/linuxbrew/.linuxbrew/bin/brew ]] && [[ ! -x "${HOME}/.linuxbrew/bin/brew" ]]; then
  echo 'Install Linuxbrew'

  # Install Dependencies
  sudo apt -y install build-essential curl file git

  # Install Linuxbrew
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

  if [[ -d ${HOME}/.cache ]]; then
    sudo chown "${USER}": "${HOME}/.cache"
  fi
fi
echo # }}}

echo 'Set Linuxbrew environment variables.' # {{{
set +u
if [[ -d "${HOME}/.linuxbrew" ]]; then
  eval "$("${HOME}/.linuxbrew/bin/brew" shellenv)"
elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  echo 'Linuxbrew is not installed.' >&2
  exit
fi
set -u

echo # }}}

echo 'Install Git.' # {{{
brew install git

echo # }}}

echo 'Install Zsh.' # {{{
brew install zsh

echo '  Add Zsh path to /etc/shells'
_shells_file=/etc/shells
_zsh_path=$(which zsh)
if ! grep -q "${_zsh_path}" <"${_shells_file}"; then
  sudo sh -c "echo ${_zsh_path} >>${_shells_file}"
fi

echo # }}}

echo 'Install programming languages.' # {{{
brew install \
  go \
  python \
  python@2 \
  php \
  composer \
  node \
  yarn

echo # }}}

echo 'Install tools.' # {{{
brew tap z80oolong/tmux
brew install \
  ghq \
  tig \
  git-now \
  fzf \
  ripgrep \
  z80oolong/tmux/tmux

go get -d github.com/lemonade-command/lemonade
cd "${GOPATH}/src/github.com/lemonade-command/lemonade/"
make install

go get github.com/b4b4r07/gist

pip3 install --user \
  powerline-status \
  psutil

brew install \
  autoconf \
  automake \
  libtool
git clone https://github.com/fumiyas/wcwidth-cjk /tmp/wcwidth-cjk
_pwd="$(pwd)"
cd /tmp/wcwidth-cjk
git checkout -b "v$(date +'%Y%m%d')" master
autoreconf --install
./configure --prefix="${HOME}/.opt/wcwidth-cjk"
make -j2
make install
cd "${_pwd}"
rm -rf /tmp/wcwidth-cjk

echo # }}}

echo 'Install Neovim.' # {{{
brew install \
  neovim \
  lynx \
  shellcheck

ln -s "${HOMEBREW_PREFIX}/bin/nvim" "${HOME}/.bin/vim"

if which pecl &>/dev/null; then
  pecl install msgpack
fi

if which pip2 &>/dev/null; then
  pip2 install --user \
    neovim
fi

pip3 install --user \
  neovim \
  flake8 \
  hacking \
  pep8-naming \
  vim-vint

go get github.com/haya14busa/go-vimlparser/cmd/vimlparser

if which composer &>/dev/null; then
  composer global require jdorn/sql-formatter:dev-master
fi

if which npm &>/dev/null; then
  npm install --global neovim
fi

if which yarn &>/dev/null; then
  yarn global add tern
fi

# TODO Install PHP Manual
# echo '  Install PHP Manual. (for plugin)'
# refs_dir=${XDG_CACHE_HOME}/vim/refs
# phpmanual_dir=${refs_dir}/php-chunked-xhtml
# if [[ ! -d ${phpmanual_dir} ]]; then
#   wget -q -O /tmp/php_manual_ja.tar.gz \
#     http://jp2.php.net/get/php_manual_ja.tar.gz/from/this/mirror
#
#   if [[ ! -d ${refs_dir} ]]; then
#     mkdir -p "${refs_dir}"
#   fi
#
#   cd "${refs_dir}"
#   tar xzf /tmp/php_manual_ja.tar.gz
# fi
echo # }}}

echo 'Clone dotfiles repo.' # {{{
git clone https://github.com/yyotti/dotfiles "${DOTFILES}"

echo '  Install dotfiles'
bash "${DOTFILES}/scripts/dotinstall.sh" -v install

echo # }}}

echo "Setup finished."

if [[ $SHELL != "${_zsh_path}" ]]; then
  echo 'Change login shell'
  chsh -s "${_zsh_path}"
fi

if which gist &>/dev/null; then
  echo 'Rem: Configure gist (run: gist config)'
fi
