#!/usr/bin/env bash
set -eu

echo 'Install GHQ.'
go get -v github.com/motemen/ghq
find "${GOPATH}/src/github.com/motemen/ghq" -type d -name '.git' -prune \
  -o -type d -exec chmod 755 {} \;

echo
