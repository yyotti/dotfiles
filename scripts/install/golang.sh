#!/usr/bin/env bash
set -eu

export GOPATH=${GOPATH:-${XDG_DATA_HOME}/go}
if [[ ! -d ${GOPATH} ]]; then
  mkdir -p "${GOPATH}"
fi

echo 'Install Golang.'
readonly go_ver=$( \
  curl -sL https://api.github.com/repos/golang/go/branches \
  | jq -r '.[]|select(.name|startswith("release-branch.go")).name' \
  | sort -r \
  | head -n 1 \
  | sed 's/release-branch\.//' \
  )
if [[ ${go_ver} != '' ]]; then
  archi=$(uname -sm)
  case "${archi}" in
    Linux\ *64) archive_name=${go_ver}.linux-amd64.tar.gz ;;
    Linux\ *86) archive_name=${go_ver}.linux-386.tar.gz ;;
    *) echo "Unknown OS: ${archi}"; exit 1 ;;
  esac
  cd /tmp
  curl -sLO "https://storage.googleapis.com/golang/${archive_name}"
  sudo tar -C /usr/local -xzf "${archive_name}"

  echo '  Install Dep.'
  "${GOPATH}/bin/go" get -v github.com/golang/dep/cmd/dep
fi

echo
