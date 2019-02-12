##############################################################################
# ZSH completions
#

# TODO
# find ${HOMEBREW_PREFIX}/opt/*/share/zsh/site-functions -type d

# git
if (( ${+commands[git]} )); then
  # git-now
  if (( ${+commands[git-now]} )); then
    fpath=(${HOMEBREW_PREFIX}/opt/git-now/share/zsh/site-functions(N-/) ${fpath})
  fi

  # git-xxx original subcommands
  fpath=(${DOTFILES}/scripts/git/completions(N-/) ${fpath})
fi

# ghq
if (( ${+commands[ghq]} )); then
  fpath=(${HOMEBREW_PREFIX}/opt/ghq/share/zsh/site-functions(N-/) ${fpath})
fi

# gist
if (( ${+commands[gist]} )); then
  fpath=(${GOPATH}/src/github.com/b4b4r07/gist/misc/completion/zsh(N-/) ${fpath})
fi

# rg
if (( ${+commands[rg]} )); then
  fpath=(${HOMEBREW_PREFIX}/opt/ripgrep/share/zsh/site-functions(N-/) ${fpath})
fi

zstyle ':completion:*' cache-path ${XDG_CACHE_HOME}/zsh/completion-cache
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' verbose yes
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:descriptions' format '%F{011}%d%f'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:warnings' format 'No matches for: %d'

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin \
                                           /usr/local/bin \
                                           /usr/sbin \
                                           /usr/bin \
                                           /sbin \
                                           /bin

# LS_COLORSが設定されているなら補完にも同じ色を設定する
if [[ ${LS_COLORS} != '' ]]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# Shift+Tab : reverse menu
bindkey '^[[Z' reverse-menu-complete
