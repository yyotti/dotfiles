#!/usr/bin/env bash
set -eu

echo 'Install CLI tools.'

echo '  Install Fuzzy Finder.'
go get -v github.com/junegunn/fzf
ln -s "${GOPATH}/src/github.com/junegunn/fzf/bin/fzf-tmux" "${GOPATH}/bin/fzf-tmux"

echo '  Install The Platinum Searcher.'
go get -v github.com/monochromegane/the_platinum_searcher/cmd/pt

echo '  Install fd.'
fd_ver=$( \
  curl -sL https://api.github.com/repos/sharkdp/fd/tags \
  | jq -r '.[].name' \
  | sort -r \
  | head -n 1
  )
if [[ ${fd_ver} != '' ]]; then
  archi=$(uname -sm)
  case "${archi}" in
    Linux\ *64) archive_name=fd-${fd_ver}-x86_64-unknown-linux-gnu.tar.gz ;;
    Linux\ *86) archive_name=fd-${fd_ver}-i686-unknown-linux-gnu.tar.gz ;;
    *) echo "Unknown OS: ${archi}"; exit 1 ;;
  esac
  cd /tmp
  curl -sLO "https://github.com/sharkdp/fd/releases/download/${fd_ver}/${archive_name}"
  tar xzf "/tmp/${archive_name}"
  mv "/tmp/${archive_name%.tar.gz}" "${XDG_DATA_HOME}/fd"
  chmod 755 "${XDG_DATA_HOME}/fd"
  mkdir -p "${HOME}/bin"
  ln -s "${XDG_DATA_HOME}/fd/fd" "${HOME}/bin/fd"
fi

echo '  Install Lemonade.'
go get -v github.com/pocke/lemonade

echo
