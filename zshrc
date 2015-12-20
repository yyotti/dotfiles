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

#export JAVA_HOME=$HOME/opt/jdk/jdk1.8.0_45

# キーバインドをviモードに
bindkey -v

# エイリアス
alias ls='ls --color=auto'
alias ll='ls -lF'
alias la='ls -A'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias -g G='| grep'
alias -g L='| less'
alias tsp='tmux new-session \; split-window -h -d'
alias tvsp='tmux new-session \; split-window -d'

# cd履歴をスタックに追加する
setopt auto_pushd
# 重複したディレクトリは記録しない
setopt pushd_ignore_dups
# 入力したコマンドが存在せず、かつその名前のディレクトリがあるなら、cdする
setopt auto_cd
# プロンプト定義内で変数置換やコマンド置換を扱う
setopt prompt_subst
# バックグラウンドジョブの状態変化を即時報告する
setopt notify

# gitリポジトリのrootディレクトリにcdできるプラグインをロードする
if [ -e $HOME/git/cd-gitroot ]; then
  fpath=($HOME/git/cd-gitroot(N-/) $fpath)
  autoload -Uz cd-gitroot
  alias cdr='cd-gitroot'
fi

# 補完
autoload -U compinit; compinit
setopt auto_list # 補完候補を一覧で表示する
setopt auto_menu # 補完キー連打で補完候補を順に表示する
setopt list_packed # 補完候補をできるだけ詰めて表示する
setopt list_types # 補完候補にファイルの種類も表示する
bindkey "^[[Z" reverse-menu-complete # Shift+Tabで補完候補を逆順にする
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完時に大文字小文字を区別しない

# コマンド訂正
setopt correct

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
_prompt="%F{cyan}[%n@%m:%F{green}%~%f %F{cyan}%D{%Y/%m/%d %T}]%f"
_prompt2="%F{cyan}%_> %f"
_sprompt="%F{yellow}%r is correct? [Yes, No, Abort, Edit]:%f"
if [ ${UID} -eq 0 ]; then
  # rootになったら太字にしてアンダーラインをひく
  _prompt="%B%U${_prompt}%u%b"
  _prompt2="%B%U${_prompt2}%u%b"
  _sprompt="%B%U${_sprompt}%u%b"
fi
PROMPT="$_prompt
%# "
PROMPT2=$_prompt2
SPROMPT=$_sprompt

# プロンプトにGitの情報を表示する
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload -Uz is-at-least
autoload -Uz colors

# 以下の3つのメッセージをエクスポートする
#   $vcs_info_msg_0_: 通常メッセージ用(緑)
#   $vcs_info_msg_1_: 警告メッセージ用(黄)
#   $vcs_info_msg_2_: エラーメッセージ用(赤)
zstyle ':vcs_info:*' max-exports 3

zstyle ':vcs_info:*' enable git svn hg bzr
# 標準のフォーマット(git 以外で使用)
# misc(%m)は通常は空文字列に置き換えられる
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b]' '%m' '<!%a>'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

if is-at-least 4.3.10; then
  # git用のフォーマット
  # gitのときはステージしているかどうかを表示
  zstyle ':vcs_info:git:*' formats '(%s)-[%b]' '%c%u %m'
  zstyle ':vcs_info:git:*' actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "+" # %cで表示する文字列
  zstyle ':vcs_info:git:*' unstagedstr "-" # %uで表示する文字列
fi

# hooks設定
if is-at-least 4.3.11; then
  # gitのときはフック関数を設定する

  # formats '(%s)-[%b]' '%c%u %m' , actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
  # のメッセージを設定する直前のフック関数
  # 今回の設定の場合はformatの時は2つ、actionformatsの時は3つメッセージがあるので
  # 各関数が最大3回呼び出される
  zstyle ':vcs_info:git+set-message:*' hooks git-hook-begin git-untracked git-push-status git-nomerge-branch git-stash-count

  # フックの最初の関数
  # gitの作業コピーのあるディレクトリのみフック関数を呼び出すようにする
  # (.gitディレクトリ内にいるときは呼び出さない)
  # .gitディレクトリ内では git status --porcelain などがエラーになるため
  +vi-git-hook-begin() {
    if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
      # 0以外を返すとそれ以降のフック関数は呼び出されない
      return 1
    fi

    return 0
  }

  # untrackedファイル表示
  #
  # untrackedファイルがある場合はunstaged(%u)に?を表示
  +vi-git-untracked() {
    # zstyle formats, actionformatsの2番目のメッセージのみ対象にする
    if [[ "$1" != "1" ]]; then
      return 0
    fi

    if command git status --porcelain 2> /dev/null | awk '{print $1}' | command grep -F '??' > /dev/null 2>&1 ; then
      # unstaged(%u)に追加
      hook_com[unstaged]+='?'
    fi
  }

  # pushしていないコミットの件数表示
  #
  # リモートリポジトリにpushしていないコミットの件数を pN という形式でmisc(%m)に表示する
  +vi-git-push-status() {
    # zstyle formats, actionformatsの2番目のメッセージのみ対象にする
    if [[ "$1" != "1" ]]; then
      return 0
    fi

    if [[ "${hook_com[branch]}" != "master" ]]; then
      # masterブランチでなければ何もしない
      return 0
    fi

    # pushしていないコミット数を取得
    local ahead
    ahead=$(command git rev-list origin/master..master 2>/dev/null | wc -l | tr -d ' ')

    if [[ "$ahead" -gt 0 ]]; then
      # misc(%m)に追加
      hook_com[misc]+="(p${ahead})"
    fi
  }

  # マージしていない件数表示
  #
  # master以外のブランチにいる場合に、現在のブランチ上でまだmasterにマージしていないコミットの
  # 件数を(mN)という形式でmisc(%m)に表示
  +vi-git-nomerge-branch() {
    # zstyle formats, actionformatsの2番目のメッセージのみ対象にする
    if [[ "$1" != "1" ]]; then
      return 0
    fi

    if [[ "${hook_com[branch]}" == "master" ]]; then
      # masterブランチの場合は何もしない
      return 0
    fi

    local nomerged
    nomerged=$(command git rev-list master..${hook_com[branch]} 2>/dev/null | wc -l | tr -d ' ')

    if [[ "$nomerged" -gt 0 ]]; then
      # misc(%m)に追加
      hook_com[misc]+="(m${nomerged})"
    fi
  }

  # stash件数表示
  #
  # stashしている場合は:SNという形式でmisc(%m)に表示
  +vi-git-stash-count()
  {
    # zstyle formats, actionformatsの2番目のメッセージのみ対象にする
    if [[ "$1" != "1" ]]; then
      return 0
    fi

    local stash
    stash=$(command git stash list 2>/dev/null | wc -l | tr -d ' ')

    if [[ "${stash}" -gt 0 ]]; then
      # misc(%m)に追加
      hook_com[misc]+=":S${stash}"
    fi
  }
fi

_update_vcs_info_msg()
{
  local -a messages
  local prompt

  LANG=en_US.UTF-8 vcs_info

  if [[ -z ${vcs_info_msg_0_} ]]; then
    # vcs_infoで何も取得していない場合はプロンプトを表示しない
    prompt=""
  else
    # vcs_infoで情報を取得した場合
    # $vcs_info_msg_0_, $vcs_info_msg_1_, $vcs_info_msg_2_ をそれぞれ緑、黄、赤で表示する
    [[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{green}${vcs_info_msg_0_}%f" )
    [[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}%f" )
    [[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )

    # 間にスペースを入れて連結する
    prompt="${(j: :)messages}"
  fi

  RPROMPT="$prompt"
}
add-zsh-hook precmd _update_vcs_info_msg

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

if [ -z "$TMUX" -a -z "$STY" ]; then
  if type tmuxx >/dev/null 2>&1; then
    tmuxx
  elif type tmux >/dev/null 2>&1; then
    if tmux has-session && tmux list-sessions | egrep -q '.*]$'; then
      # デタッチ済みセッションが存在する
      tmux attach && echo "tmux attached session"
    else
      tmux new-session && echo "tmux created new session"
    fi
  elif type screen >/dev/null 2>&1; then
    screen -rx || screen -D -RR
  fi
fi

# vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:
