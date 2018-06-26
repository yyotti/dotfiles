#!/usr/bin/env bash
set -eu

echo 'Install CLI tools.'

echo '  Install Fuzzy Finder.'
go get -v github.com/junegunn/fzf
ln -s "${GOPATH}/src/github.com/junegunn/fzf/bin/fzf-tmux" "${GOPATH}/bin/fzf-tmux"

echo '  Install ripgrep.'
archi=$(uname -sm)
case "${archi}" in
  Linux\ *64) pattern=x86_64-unknown-linux-musl.tar.gz ;;
  Linux\ *86) pattern=i686-unknown-linux-musl.tar.gz ;;
  *) echo "Unknown OS: ${archi}"; pattern='' ;;
esac
if [[ ${pattern} != '' ]]; then
  archive_name=$( \
    curl -sL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest \
    | jq -r '.assets[].name' \
    | grep -E "^ripgrep-[0-9.]+-${pattern}$" \
  )

  cd /tmp
  curl -sLO "$( \
    echo "$archive_name" \
    | sed -E 's#^ripgrep-([0-9.]+)-.+$#https://github.com/BurntSushi/ripgrep/releases/download/\1/\0#' \
  )"
  tar xzf "/tmp/${archive_name}"
  mv "/tmp/${archive_name%.tar.gz}" "${XDG_DATA_HOME}/ripgrep"
  chmod 755 "${XDG_DATA_HOME}/ripgrep"
  mkdir -p "${HOME}/bin"
  ln -s "${XDG_DATA_HOME}/ripgrep/rg" "${HOME}/bin/rg"
fi

echo '  Install Lemonade.'
go get -v github.com/pocke/lemonade

echo
