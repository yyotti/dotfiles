##############################################################################
# fzf
#

if [[ ! ${-} =~ i ]] || ! (( ${+commands[fzf]} )); then
  return
fi

source "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.zsh"
source "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.zsh"

# TODO プロンプトに入力している文字列であらかじめ絞りたい

function fzf-ghq-widget()
{
  setopt localoptions pipefail 2>/dev/null

  local _dir
  _dir=( $(ghq list --full-path | $(__fzfcmd)) )
  local _ret=${?}

  if [[ ${_dir} == '' ]]; then
    zle redisplay
    return 0
  fi

  LBUFFER="${LBUFFER}${_dir}"
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return ${_ret}
}

function fzf-vim-plugins-widget()
{
  local _vim_plugins_dir="${XDG_CACHE_HOME}/vim/dein/repos"
  local _dir=''
  local _ret=0

  if [[ -d ${_vim_plugins_dir} ]]; then
    setopt localoptions pipefail 2>/dev/null

    _dir=( $(find "${_vim_plugins_dir}" -maxdepth 3 -mindepth 3 -type d | $(__fzfcmd)) )
    _ret=${?}
  fi

  if [[ ${_dir} == '' ]]; then
    zle redisplay
    return 0
  fi

  LBUFFER="${LBUFFER}${_dir}"
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return ${_ret}
}

function fzf-git-branch-widget()
{
  setopt localoptions pipefail 2>/dev/null

  local _branches=$(git branch -v 2>/dev/null)
  local _branch=$(echo "${_branches}" | $(__fzfcmd))
  local _ret=${?}

  if [[ ${_branch} == '' ]]; then
    zle redisplay
    return 0
  fi

  LBUFFER="${LBUFFER}$(echo "${_branch}" | awk '{print $1}' | sed "s/.* //")"
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return ${_ret}
}

zle -N fzf-ghq-widget
bindkey '^L' fzf-ghq-widget

zle -N fzf-vim-plugins-widget
bindkey '^V' fzf-vim-plugins-widget

zle -N fzf-git-branch-widget
bindkey '^X' fzf-git-branch-widget

# Change default keybinds
# bindkey '^F' fzf-file-widget
bindkey -r '\ec'
