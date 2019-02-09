##############################################################################
# ZSH histories
#
autoload -Uz history-search-end

HISTFILE=${XDG_CACHE_HOME}/zsh/history
HISTSIZE=10000
SAVEHIST=10000

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey '^P' history-beginning-search-backward-end
bindkey '^N' history-beginning-search-forward-end
