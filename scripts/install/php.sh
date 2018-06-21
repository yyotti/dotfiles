#!/usr/bin/env bash
set -eu

echo 'Install PHP 5.6.'
sudo add-apt-repository -y ppa:ondrej/php
sudo apt -y install \
  php5.6 \
  php5.6-gd \
  php5.6-mbstring \
  php5.6-xml \
  php5.6-zip

echo
