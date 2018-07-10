#!/usr/bin/env bash
set -eu

echo 'Install PHP 5.6.'
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update
sudo apt -y install \
  php5.6 \
  php5.6-gd \
  php5.6-mbstring \
  php5.6-mysql \
  php5.6-xml \
  php5.6-zip

echo '  Install Composer.'
expected_signature=$(wget -q -O - https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');"
actual_signature=$(php -r "echo hash_file('SHA384', '/tmp/composer-setup.php');")
if [[ ${expected_signature} != ${actual_signature} ]]; then
  echo 'Error: Invalid installer signature' >&2
  rm -f /tmp/composer-setup.php
  exit 1
fi

php /tmp/composer-setup.php \
  --install-dir="${HOME}/bin" \
  --filename=composer

rm -f /tmp/composer-setup.php

echo
