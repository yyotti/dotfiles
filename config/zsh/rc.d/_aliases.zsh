##############################################################################
# ZSH aliases
#
alias ls='ls -hF --color=auto --time-style="+%Y/%m/%d %H:%M:%S"'
alias ll='ls -l'
alias la='ll -A'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias sudo='sudo '
alias lspath='echo "${PATH//:/\n}"'

alias ssh='(){tmux select-pane -P "bg=colour235"; command ssh "$@"; tmux select-pane -P "fg=default,bg=default"}'

if (( ${+commands[tig]} )); then
  alias tiga='tig --all'
  alias tigr='tig refs'
  alias tigs='tig status'
fi

if (( ${+commands[fzf]} )); then
  alias -g F='| fzf'
fi

if (( ${+commands[pt]} )); then
  alias pt='pt --smart-case --nogroup'
fi

if (( ${+commands[rg]} )); then
  alias rg='rg --no-heading --column'
fi

if (( ${+commands[docker.exe]} )); then
  alias d='docker.exe'
elif (( ${+commands[docker]} )); then
  alias d='docker'
fi
