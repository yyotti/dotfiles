#!/usr/bin/env bash
set -eu

echo 'Install Git tools.'

echo '  Install tig.'
repo=jonas/tig
ghq get ${repo}
cd "$(ghq root)/github.com/${repo}"
ver=$(git tag | tail -n 1)
git checkout -b "v${ver}" "${ver}"
./autogen.sh
./configure
make prefix=/usr/local
sudo make install prefix=/usr/local

echo '  Install git-now.'
repo=iwata/git-now
ghq get ${repo}
cd "$(ghq root)/github.com/${repo}"
find . -type d -name '.git' -prune -o -type d -exec chmod 755 {} \;
git submodule init
git submodule update
sudo make install

echo '  Install gist.'
go get -v -u github.com/b4b4r07/gist
find "${GOPATH}/src/github.com/b4b4r07/gist/misc/completion" \
  -type d -name '.git' -prune -o -type d -exec chmod 755 {} \;

echo

