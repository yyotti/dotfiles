# zmodload zsh/zprof && zprof
umask 022

# XDG Base Directory
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

export DOTFILES=${XDG_DATA_HOME}/dotfiles
export ZDOTDIR=${XDG_CONFIG_HOME}/zsh

source "${ZDOTDIR}/zshenv"
