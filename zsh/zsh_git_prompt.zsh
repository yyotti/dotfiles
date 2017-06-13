#!/usr/bin/env zsh

source_file="${ZDOTDIR:-$HOME}/plugins/olivierverdier/zsh-git-prompt/zshrc.sh"
if [[ ! -f $source_file ]]; then
  exit 0
fi

source "$source_file"
cd "${1:-$(pwd)}"
git_super_status
