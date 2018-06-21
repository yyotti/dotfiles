#!/usr/bin/env bash
set -eu

echo 'Install Zsh.'
sudo apt -y install zsh

echo '  Add Zsh path to /etc/shells'
_zsh_path=$(which zsh)
if ! grep -q "${_zsh_path}" </etc/shells; then
  sudo "$(which bash)" -c "echo ${_zsh_path} >>/etc/shells"
fi

echo
