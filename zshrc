# Created by newuser for 5.0.2

if [ `which vim` ]; then
  # エディタをvimに設定
  export EDITOR=vim
fi
# 文字コードをUTF-8に
export LANG=ja_JP.UTF-8
# KCODEにUTF-8を設定
export KCODE=u
# autotestでfeatureを動かす
export AUTOFEATURE=true

# キーバインドをviモードに
bindkey -v

# TODO エイリアスを設定

# cd履歴をスタックに追加する
setopt auto_pushd
# 入力したコマンドが存在せず、かつその名前のディレクトリがあるなら、cdする
setopt auto_cd
# プロンプト定義内で変数置換やコマンド置換を扱う
setopt prompt_subst
# バックグラウンドジョブの状態変化を即時報告する
setopt notify

# 補完
autoload -U compinit; compinit
setopt auto_list # 補完候補を一覧で表示する
setopt auto_menu # 補完キー連打で補完候補を順に表示する
setopt list_packed # 補完候補をできるだけ詰めて表示する
setopt list_types # 補完候補にファイルの種類も表示する
bindkey "^[[Z" reverse-menu-complete # Shift+Tabで補完候補を逆順にする
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完時に大文字小文字を区別しない

# 履歴
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt bang_hist # !を使ったヒストリ展開を行う
setopt hist_ignore_dups # 入力したコマンドがコマンド履歴に含まれる場合は、古い方を削除する
setopt share_history
setopt hist_reduce_blanks
setopt hist_ignore_space # コマンドがスペースで始まる場合は履歴に追加しない

# マッチしたコマンドのヒストリを表示
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# 色の設定
export LSCOLORS=Exfxcxdxbxegedabagacad
# 補完時の色
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# ZSH_COLORS
export ZSH_COLORS=$LS_COLORS
# lsコマンドの時、色をつける
export CLICOLOR=true
# 補完候補に色
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# プロンプト
_prompt="%F{cyan}[%n@%m %D{%m/%d %T}]%f"
_prompt2="%F{cyan}%_> %f"
_rprompt="%F{green}[%~]%f"
_sprompt="%F{yellow}%r is correct? [Yes, No, Abort, Edit]:%f"
if [ ${UID} -eq 0 ]; then
  # rootになったら太字にしてアンダーラインをひく
  _prompt="%B%U${_prompt}%u%b# "
  _prompt2="%B%U${_prompt2}%u%b"
  _rprompt="%B%U${_rprompt}%u%b"
  _sprompt="%B%U${_sprompt}%u%b"
else
  _prompt="${_prompt}$ "
fi
PROMPT=$_prompt
PROMPT2=$_prompt2
RPROMPT=$_rprompt
SPROMPT=$_sprompt

# タイトルにカレントディレクトリを表示
precmd() {
  [[ -t 1 ]] || return
  case $TERM in
    *xterm*|rxvt|(dt|k|E)term)
      print -Pn "\e]2;[%~]\a"
      ;;
    # screen)
      #      #print -Pn "\e]0;[%n@%m %~] [%l]\a"
      #      print -Pn "\e]0;[%n@%m %~]\a"
      #      ;;
    esac
}

# vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:
