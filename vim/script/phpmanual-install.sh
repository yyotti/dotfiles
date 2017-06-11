#!/usr/bin/env bash

refs_dir=$HOME/.vim/refs
if [[ ! -d $refs_dir ]]; then
  mkdir -p "$refs_dir"
fi

phpmanual_dir=$refs_dir/php-chunked-xhtml
if [[ ! -d $phpmanual_dir ]]; then
  wget -O /tmp/php_manual_ja.tar.gz \
    http://jp2.php.net/get/php_manual_ja.tar.gz/from/this/mirror

  mkdir -p "$refs_dir"
  cd "$refs_dir"
  tar xzf /tmp/php_manual_ja.tar.gz
fi

