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
  skkdic \
  shellcheck

echo
