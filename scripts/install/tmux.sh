#!/usr/bin/env bash
set -eu

echo 'Install tmux'

echo '  Install wcwidth.'
sudo apt -y install \
  autoconf \
  automake \
  libtool

repo=fumiyas/wcwidth-cjk
ghq get ${repo}
cd "$(ghq root)/github.com/${repo}"
ver=$(date +'%Y%m%d')
git checkout -b "v${ver}" master
autoreconf --install
./configure --prefix=/usr/local/
make -j2
sudo make install

# https://gist.github.com/z80oolong/e65baf0d590f62fab8f4f7c358cbcc34
echo '  Install tmux.'
sudo apt -y install \
  libevent-2.0-5 \
  libevent-dev \
  libncurses5-dev
repo=tmux/tmux
ghq get ${repo}
cd "$(ghq root)/github.com/${repo}"
ver='2.7'
git checkout -b "v${ver}" "${ver}"
git apply --verbose --binary <(curl -sL https://gist.githubusercontent.com/z80oolong/e65baf0d590f62fab8f4f7c358cbcc34/raw/e4cf9c15d715826299b9e5ba3480b32ac20545de/tmux-2.7-fix.diff)
sh autogen.sh
./configure
make -j2
sudo make install
sudo update-alternatives --install /usr/bin/tmux tmux /usr/local/bin/tmux 50

echo '  Install Powerline.'
sudo pip3 install powerline-status psutil

echo
