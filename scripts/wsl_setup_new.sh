umask 022

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-${HOME}/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-${HOME}/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-${HOME}/.local/share}

# Golang
export GOPATH=${GOPATH:-${XDG_DATA_HOME}/go}
export PATH="${GOPATH}/bin:${PATH}"

# Rust
export RUSTUP_HOME=${XDG_DATA_HOME}/rustup
export CARGO_HOME=${XDG_DATA_HOME}/cargo
export PATH="${CARGO_HOME}/bin:${PATH}"

# asdf
export ASDF_DATA_DIR=${ASDF_DATA_DIR:-${XDG_DATA_HOME}/asdf}
export PATH="${ASDF_DATA_DIR}/bin:${PATH}"

# Dotfiles
export DOTFILES=${DOTFILES:-${XDG_DATA_HOME}/dotfiles}

echo 'Create directories' # {{{
mkdir -p \
  "${HOME}/.bin" \
  "${XDG_CONFIG_HOME}" \
  "${XDG_CACHE_HOME}" \
  "${XDG_DATA_HOME}" \
  ;

echo # }}}

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
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y autoremove

sudo apt -y install \
  language-pack-ja \
  manpages-ja \
  skkdic \
  ;

echo 'Install Linuxbrew (http://linuxbrew.sh/)' # {{{
if [[ ! -x /home/linuxbrew/.linuxbrew/bin/brew ]] && [[ ! -x "${HOME}/.linuxbrew/bin/brew" ]]; then
  echo 'Install Linuxbrew'

  # Install Dependencies
  sudo apt-get -y install build-essential curl file git

  # Install Linuxbrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

  if [[ -d ${HOME}/.cache ]]; then
    sudo chown "${USER}": "${HOME}/.cache"
  fi
fi
echo # }}}

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export LD_LIBRARY_PATH="${HOMEBREW_PREFIX}/lib:/usr/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH}"

brew install git

brew install zsh
echo '  Add Zsh path to /etc/shells'
_shells_file=/etc/shells
_zsh_path=$(command -v zsh)
if ! grep -q "${_zsh_path}" <"${_shells_file}"; then
  sudo sh -c "echo ${_zsh_path} >>${_shells_file}"
fi

echo # }}}

brew tap z80oolong/tmux
brew install \
  ghq \
  tig \
  git-now \
  fzf \
  ripgrep \
  z80oolong/tmux/tmux \
  zip \
  unzip \
  asdf \
  ;
  
source "${HOMEBREW_PREFIX}/opt/asdf/asdf.sh"

# golang
asdf plugin add golang
asdf install golang 1.14.2
asdf global golang 1.14.2

# python
sudo apt-get -y install --no-install-recommends \
  make \
  build-essential \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  wget \
  curl \
  llvm \
  libncurses5-dev \
  xz-utils \
  tk-dev \
  libxml2-dev \
  libxmlsec1-dev \
  libffi-dev \
  liblzma-dev \
  ;
  
# その時点での最新を入れるがdevは除いておく（いい方法は無いものか？）
# pythonはenv系もあるので普通のを入れる。
asdf plugin add python
asdf install python 3.8.3
asdf install python 2.7.18
asdf global python 3.8.3 2.7.18

# PHPに必要なものはworkflow.ymlにある
# PHP5にはbison3.0以外が必要なのでbrewで入れる。※3.0.xさえ避ければいい。
# add-apt-repository で2系のPPAを追加してもいいのだが、なんか not found とかになるうえに、
# PHP7にはbison3が必要。
brew install bison
sudo apt -y install \
  autoconf \
  build-essential \
  curl \
  gettext \
  libcurl4-openssl-dev \
  libedit-dev \
  libicu-dev \
  libjpeg-dev \
  libmysqlclient-dev \
  libonig-dev \
  libpng-dev \
  libpq-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  libxml2-dev \
  libzip-dev \
  openssl \
  pkg-config \
  re2c \
  zlib1g-dev \
  ;
  
# ↓もPHP5をインストールする場合のみ。
sudo ln -s "${HOMEBREW_PREFIX}/include/curl" /usr/local/include/curl
# aptで入れたcurlを参照させたいなら↓のようにする？
# sudo ln -s /usr/lib/x86_64-linux-gnu/curl /usr/local/include/curl

# PHPは5系が不要になったら↓でいい
# asdf plugin add php
asdf plugin add php https://github.com/yyotti/asdf-php

# 依存関係をaptで入れたなら、pkg-configもbrewじゃない方を使う必要がある。
# 例）
#   libxml2-dev をaptで入れたけど pkg-config がbrewのものを使うと見つからない。
# PKG_CONFIG_PATH を設定し、brewのpkg-configが見にいくパスを追加してやる。
PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig:${PKG_CONFIG_PATH}" asdf install php 7.4.5
asdf install php 5.6.40
asdf global php 7.4.5

# nodejs
asdf plugin add nodejs
bash "${ASDF_DATA_DIR}/plugins/nodejs/bin/import-release-team-keyring"
asdf install nodejs 14.3.0
asdf global nodejs 14.3.0

# yarn
asdf plugin add yarn
asdf install yarn 1.22.4  # なんかエラーみたいなの出るかもしれないが、入ってるぽい
asdf global yarn 1.22.4

# Rust
curl https://sh.rustup.rs -sSf | sh  # インストーラみたいになるがデフォルトでいいはず。

# Neovim
brew install neovim
sudo update-alternatives --install /usr/bin/vi vi "${HOMEBREW_PREFIX}/bin/nvim" 60
sudo update-alternatives --install /usr/bin/vim vim "${HOMEBREW_PREFIX}/bin/nvim" 60
sudo update-alternatives --install /usr/bin/editor editor "${HOMEBREW_PREFIX}/bin/nvim" 60 
python3 -m pip install --user --upgrade pynvim
python2 -m pip install --user --upgrade pynvim

# tmux
brew install \
  autoconf \
  automake \
  libtool \
  make \
  ;
git clone https://github.com/fumiyas/wcwidth-cjk /tmp/wcwidth-cjk
(
  cd /tmp/wcwidth-cjk
  git checkout -b "v$(date +'%Y%m%d')" master
  autoreconf --install
  ./configure --prefix="${HOME}/.opt/wcwidth-cjk"
  make -j2
  make install
)
pip3 install --user \
  powerline-status \
  psutil \
  ;

# Language Servers

# rust
rustup component add rls rust-analysis rust-src
# Language ServerではないがWASMやるなら
curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
cargo install cargo-generate

# golang
GO111MODULE=on go get -u -v golang.org/x/tools/gopls@latest
# あとLinters
GO111MODULE=on go get -u -v golang.org/x/tools/cmd/goimports
brew install golangci/tap/golangci-lint

# intelephense
yarn global add intelephense

# dotfiles
# なんか ${XDG_CACHE_HOME}/zsh が無いといけないらしいが、作ってないのか？
git clone https://github.com/yyotti/dotfiles "${DOTFILES}"
bash "${DOTFILES}/scripts/dotinstall.sh" -v install