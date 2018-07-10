#!/usr/bin/env bash
set -eu

echo 'Install Python/Python3'
sudo apt -y install \
  python \
  python-pip \
  python3 \
  python3-pip

sudo pip3 install --upgrade pip

echo
