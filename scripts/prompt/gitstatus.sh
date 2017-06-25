#!/usr/bin/env bash

set -u

function __main() # {{{
{
  if ! type git >/dev/null 2>&1; then
    exit 1
  fi

  local _dir
  _dir=$(cd "${1:-$PWD}"; pwd)
  if [[ $_dir != $PWD && -d $_dir ]]; then
    cd "$_dir"
  fi

  local _repo
  _repo=( $(command git rev-parse --git-dir --is-inside-git-dir --is-bare-repository --is-inside-work-tree HEAD 2>/dev/null) )
  if [[ $? != 0 ]]; then
    exit 0
  fi

  local _git_dir=${_repo[0]}
  local _inside_gitdir=${_repo[1]}
  local _bare_repo=${_repo[2]}
  local _inside_worktree=${_repo[3]}
  local _sha=${_repo[4]}

  local _op_branch_detached=( $(__get_op_branch_detached "$_git_dir" "$_sha") )
  local _operation=${_op_branch_detached[0]#:}
  local _branch=${_op_branch_detached[1]}
  local _is_detached=${_op_branch_detached[2]}

  local _repo_status=( $(__get_repo_status "$_git_dir" "$_inside_worktree" "$_sha") )
  local _is_dirty="${_repo_status[0]}"
  local _staged_state="${_repo_status[1]}"
  local _has_stashed="${_repo_status[2]}"
  local _has_untracked="${_repo_status[3]}"
  local _upstream_name="${_repo_status[4]#:}"
  local _behind="${_repo_status[5]}"
  local _ahead="${_repo_status[6]}"

  local _unmerged
  _unmerged=$(__get_unmerged "$_branch")

  local _repo_type=0
  if [[ $_bare_repo == 'true' ]]; then
    _repo_type=1
  elif [[ $_inside_gitdir == 'true' ]]; then
    _repo_type=2
  fi

  echo \
    ":$_operation" \
    "$_branch" \
    "$_repo_type" \
    "$_is_detached" \
    "$_is_dirty" \
    "$_staged_state" \
    "$_has_stashed" \
    "$_has_untracked" \
    "$_unmerged" \
    ":$_upstream_name" \
    "$_behind" \
    "$_ahead"
}
# }}}

function __get_op_branch_detached() # {{{
{
  local _git_dir=$1
  local _sha=$2
  local _branch=''
  local _step=-1
  local _total=-1
  local _operation=''
  local _is_detached=0

  if [[ -d $_git_dir/rebase-merge ]]; then
    _branch=$(cat "$_git_dir/rebase-merge/head-name" 2>/dev/null)
    _step=$(cat "$_git_dir/rebase-merge/msgnum" 2>/dev/null)
    _total=$(cat "$_git_dir/rebase-merge/end" 2>/dev/null)
    if [[ -f $_git_dir/rebase-merge/interactive ]]; then
      _operation='|REBASE-i'
    else
      _operation='|REBASE-m'
    fi
  else
    if [[ -d $_git_dir/rebase-apply ]]; then
      _step=$(cat "$_git_dir/rebase-apply/next" 2>/dev/null)
      _total=$(cat "$_git_dir/rebase-apply/last" 2>/dev/null)
      if [[ -f $_git_dir/rebase-apply/rebasing ]]; then
        _branch=$(cat "$_git_dir/rebase-apply/head-name" 2>/dev/null)
        _operation='|REBASE'
      elif [[ -f $_git_dir/rebase-apply/applying ]]; then
        _operation='|AM'
      else
        _operation='|AM/REBASE'
      fi
    elif [[ -f $_git_dir/MERGE_HEAD ]]; then
      _operation='|MERGING'
    elif [[ -f $_git_dir/CHERRY_PICK_HEAD ]]; then
      _operation='|CHERRY-PICKING'
    elif [[ -f $_git_dir/REVERT_HEAD ]]; then
      _operation='|REVERTING'
    elif [[ -f $_git_dir/BISECT_LOG ]]; then
      _operation='|BISECTING'
    fi
  fi

  if [[ $_step -ge 0 && $_total -ge 0 ]]; then
    _operation="$_operation $_step/$_total"
  fi

  if [[ $_branch == '' ]]; then
    _branch=$(command git symbolic-ref HEAD 2>/dev/null)
    if [[ $? != 0 ]]; then
      _is_detached=1
      _branch=$(command git describe --contains --all HEAD 2>/dev/null)
      if [[ $? != 0 ]]; then
        if [[ $_sha != '' ]]; then
          _branch=${_sha[0,8]}
        else
          _branch='unknown'
        fi
      fi
    fi
  fi

  echo ":$_operation"
  echo "${_branch#refs/heads/}"
  echo "$_is_detached"
}
# }}}

function __get_repo_status() # {{{
{
  local _git_dir=$1
  local _inside_worktree=$2
  local _sha=$3

  local _is_dirty=0
  local _staged_state=0
  local _has_stashed=0
  local _has_untracked=0
  local _upstream_name=''
  local _behind=0
  local _ahead=0
  if [[ $_inside_worktree == 'true' ]]; then
    declare -A _config
    while read _key _value; do
      if [[ $_value == 'false' ]]; then
        _config[$_key]=false
      else
        _config[$_key]=true
      fi
    done < <(command git config --bool --get-regexp '^bash\.(showDirtyState|showUntrackedFiles)$')


    if ${_config['bash.showdirtystate']:-true}; then
      if ! command git diff --no-ext-diff --quiet --exit-code 2>/dev/null; then
        _is_dirty=1
      fi

      if [[ $_sha != '' ]]; then
        if ! command git diff-index --cached --quiet HEAD --; then
          _staged_state=1
        fi
      else
        _staged_state=2
      fi
    fi

    if ${_config['bash.showuntrackedfiles']:-true}; then
      if command git ls-files --others --exclude-standard --error-unmatch -- '*' >/dev/null 2>&1; then
        _has_untracked=1
      fi
    fi

    if [[ -r $_git_dir/refs/stash ]]; then
      _has_stashed=1
    fi

    local _upstream=( $(__get_upstream) )
    _upstream_name=${_upstream[0]}
    _behind=${_upstream[1]}
    _ahead=${_upstream[2]}
  fi

  echo "$_is_dirty"
  echo "$_staged_state"
  echo "$_has_stashed"
  echo "$_has_untracked"
  echo "$_upstream_name"
  echo "$_behind"
  echo "$_ahead"
}
# }}}

function __get_upstream() # {{{
{
  local _counts
  _counts=( $(command git rev-list --count --left-right '@{upstream}'...HEAD 2>/dev/null) )
  if [[ $? != 0 ]]; then
    echo ':'
    echo 0
    echo 0
    return
  fi

  local _upstream_name=''
  local _behind=0
  local _ahead=0
  if [[ "${_counts[@]}" != '' ]]; then
    _behind=${_counts[0]}
    _ahead=${_counts[1]}

    _upstream_name=$(command git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)
  fi

  echo ":$_upstream_name"
  echo "$_behind"
  echo "$_ahead"
}
# }}}

function __get_unmerged() # {{{
{
  local _branch=$1

  if [[ $_branch == 'master' ]]; then
    echo 0
    return
  fi

  local _cnt
  _cnt=$(command git rev-list master..."$_branch" | wc -l)
  if [[ $? != 0 ]]; then
    echo 0
  else
    echo "$_cnt"
  fi
}
# }}}

__main "$@"
