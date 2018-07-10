#!/usr/bin/env bash
set -eu

echo 'Install Neovim.'

echo '  Install prerequisites.'
sudo apt -y install \
  autoconf \
  automake \
  cmake \
  g++ \
  gettext \
  libtool \
  libtool-bin \
  ninja-build \
  pkg-config \
  unzip

echo '  Install Neovim.'
repo=neovim/neovim
ghq get ${repo}
cd "$(ghq root)/github.com/${repo}"
ver=$(git tag | tail -n 1)
git checkout -b "v${ver}" "${ver}"
make -j2 CMAKE_BYILD_TYPE=Release
sudo make install
sudo update-alternatives --install /usr/bin/vim vim /usr/local/bin/nvim 50

echo '  Install neovim-python'
pip install --user neovim
pip3 install --user neovim

echo '  Install some packages/commands using Neovim(plugins)'
sudo apt -y install \
  lynx \
  php-msgpack \
  skkdic \
  shellcheck

go get -v github.com/haya14busa/go-vimlparser/cmd/vimlparser

pip3 install --user \
  flake8 \
  hacking \
  pep8-naming \
  vim-vint

npm install --global \
  neovim

yarn global add \
  tern

if which composer &>/dev/null; then
  composer global require jdorn/sql-formatter:dev-master
fi

echo '  Install PHP Manual. (for plugin)'
refs_dir=${XDG_CACHE_HOME}/vim/refs
phpmanual_dir=${refs_dir}/php-chunked-xhtml
if [[ ! -d ${phpmanual_dir} ]]; then
  wget -q -O /tmp/php_manual_ja.tar.gz \
    http://jp2.php.net/get/php_manual_ja.tar.gz/from/this/mirror

  if [[ ! -d ${refs_dir} ]]; then
    mkdir -p "${refs_dir}"
  fi

  cd "${refs_dir}"
  tar xzf /tmp/php_manual_ja.tar.gz
fi

echo
