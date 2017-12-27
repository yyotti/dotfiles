#!/usr/bin/env bash
set -eu

refs_dir=${XDG_CACHE_HOME:-$HOME/.cache}/vim/refs
phpmanual_dir=$refs_dir/php-chunked-xhtml

if [[ -d $phpmanual_dir ]]; then
  exit 0
fi

wget -q -O /tmp/php_manual_ja.tar.gz \
  http://jp2.php.net/get/php_manual_ja.tar.gz/from/this/mirror

if [[ ! -d $refs_dir ]]; then
  mkdir -p "$refs_dir"
fi

cd "$refs_dir"
tar xzf /tmp/php_manual_ja.tar.gz
