#!/usr/bin/env zsh

cd "${1:-$(pwd)}"

autoload -Uz \
  vcs_info \
  is-at-least

# vcs_info {{{
prompt_git_info_separator=' '

# 以下の3つのメッセージをエクスポートする
#   $vcs_info_msg_0_: 通常メッセージ用(緑)
#   $vcs_info_msg_1_: 警告メッセージ用(黄)
#   $vcs_info_msg_2_: エラーメッセージ用(赤)
zstyle ':vcs_info:*' max-exports 3

zstyle ':vcs_info:*' enable git
if is-at-least 4.3.10; then
  zstyle ':vcs_info:git:*' formats '%b' '%c%u %m'
  zstyle ':vcs_info:git:*' actionformats '(%b)' '%c%u %m' '<!%a>'
  zstyle ':vcs_info:git:*' check-for-changes true
  # TODO ステージ/アンステージの文字を調整
  zstyle ':vcs_info:git:*' stagedstr "+" # %cで表示する文字列
  zstyle ':vcs_info:git:*' unstagedstr "*" # %uで表示する文字列
fi

# }}}

# hooks

# formats '(%s)-[%b]' '%c%u %m' , actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
# のメッセージを設定する直前のフック関数
# 今回の設定の場合はformatの時は2つ、actionformatsの時は3つメッセージがあるので
# 各関数が最大3回呼び出される
# TODO untrackedが遅い
# TODO hookは全部1つにまとめる
# TODO リモートブランチも表示
zstyle ':vcs_info:git+set-message:*' \
  hooks \
  git-hook-begin \
  git-untracked \
  git-push-status \
  git-nomerge-branch \
  git-stash-count

# フックの最初の関数
# gitの作業コピーのあるディレクトリのみフック関数を呼び出すようにする
# (.gitディレクトリ内にいるときは呼び出さない)
# .gitディレクトリ内では git status --porcelain などがエラーになるため
function +vi-git-hook-begin() {
  if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
    # 0以外を返すとそれ以降のフック関数は呼び出されない
    return 1
  fi

  return 0
}

# untrackedファイル表示
#
# untrackedファイルがある場合はunstaged(%u)に?を表示
function +vi-git-untracked() {
  # zstyle formats, actionformatsの2番目のメッセージのみ対象にする
  if [[ $1 != '1' ]]; then
    return 0
  fi

  if command git ls-files --others --exclude-standard --error-unmatch -- '*' >/dev/null 2>&1; then
    # unstaged(%u)に追加
    hook_com[unstaged]+='?'
  fi
}

# pushしていないコミットの件数表示
#
# リモートリポジトリにpushしていないコミットの件数を pN という形式でmisc(%m)に表示する
function +vi-git-push-status() {
  # zstyle formats, actionformatsの2番目のメッセージのみ対象にする
  if [[ $1 != '1' ]]; then
    return 0
  fi

  if [[ ${hook_com[branch]} != 'master' ]]; then
    # masterブランチでなければ何もしない
    return 0
  fi

  # TODO pull数も出す
  # pushしていないコミット数を取得
  local ahead="$(command git rev-list origin/master..master 2>/dev/null | wc -l | tr -d ' ')"

  if [[ $ahead -gt 0 ]]; then
    # misc(%m)に追加
    hook_com[misc]+="+${ahead}"
  fi
}

# マージしていない件数表示
#
# master以外のブランチにいる場合に、現在のブランチ上でまだmasterにマージしていないコミットの
# 件数を(mN)という形式でmisc(%m)に表示
function +vi-git-nomerge-branch() {
  # zstyle formats, actionformatsの2番目のメッセージのみ対象にする
  if [[ $1 != '1' ]]; then
    return 0
  fi

  if [[ ${hook_com[branch]} == 'master' ]]; then
    # masterブランチの場合は何もしない
    return 0
  fi

  local nomerged="$(command git rev-list master.."${hook_com[branch]}" 2>/dev/null | wc -l | tr -d ' ')"

  if [[ $nomerged -gt 0 ]]; then
    # misc(%m)に追加
    hook_com[misc]+="*${nomerged}"
  fi
}

# stash件数表示
#
# stashしている場合は:SNという形式でmisc(%m)に表示
function +vi-git-stash-count()
{
  # zstyle formats, actionformatsの2番目のメッセージのみ対象にする
  if [[ $1 != '1' ]]; then
    return 0
  fi

  local stash="$(command git stash list 2>/dev/null | wc -l | tr -d ' ')"

  if [[ $stash -gt 0 ]]; then
    # misc(%m)に追加
    hook_com[misc]+=":S${stash}"
  fi
}

function __trim
{
  echo "$1" | sed -E 's/^\s*(.*)\s*$/\1/'
}

function __vcs_info()
{
  local _messages=()
  local _vcs_info=''

  LANG=en_US.UTF-8 vcs_info

  # TODO こんなことしなくてもいいように
  # TODO なんならfishを参考にして自前で（zshのhookだけで）やってみる
  local _msg0="$(__trim ${vcs_info_msg_0_})"
  local _msg1="$(__trim ${vcs_info_msg_1_})"
  local _msg2="$(__trim ${vcs_info_msg_2_})"

  if [[ $vcs_info_msg_0_ != '' ]]; then
    # $vcs_info_msg_x_ をそれぞれ緑、黄、赤で表示
    # TODO 色を変数にして設定
    # TODO ここではなくて各メッセージの中で指定する
    # TODO メッセージの形式をfishのプロンプトに合わせてみる
    [[ $_msg0 != '' ]] && _messages+=( "%F{green}${_msg0}%f" )
    [[ $_msg1 != '' ]] && _messages+=( "%F{yellow}${_msg1}%f" )
    [[ $_msg2 != '' ]] && _messages+=( "%F{red}${_msg2}%f" )

    _vcs_info="(${(j:|:)_messages})"
  fi

  echo "$_vcs_info"
}

__vcs_info
