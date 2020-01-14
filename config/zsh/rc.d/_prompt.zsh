##############################################################################
# ZSH prompt
#

autoload -Uz \
  add-zsh-hook \
  is-at-least \
  async

function __is_root() # {{{
{
  [[ ${UID} == 0 ]]
}
# }}}

function __init_color() # {{{
{
  local _var_name=${1}
  local _default_color=${2}
  local _root_color=${3:-${_default_color}}

  if [[ ${_var_name} == '' ]]; then
    return
  fi

  if __is_root; then
    eval ${_var_name}=${_root_color}
  else
    eval ${_var_name}=${_default_color}
  fi

  if [[ $(eval echo \$${_var_name}) != '' ]]; then
    eval ${_var_name}_start="%F{\$${_var_name}}"
    eval ${_var_name}_end='%f'
  else
    eval ${_var_name}_start=''
    eval ${_var_name}_end=''
  fi
}
# }}}

function __prompt_setup() # {{{
{
  # Initialize color variables
  # PROMPT
  __init_color prompt_color_cwd 010
  __init_color prompt_color_user 006 009
  __init_color prompt_color_host 012
  __init_color prompt_color_symbol 255
  __init_color prompt_color_symbol_error 196

  # TODO prompt_color_xxxにリネーム
  __init_color prompt_git_separator 243
  __init_color prompt_git_bare_repo 001
  __init_color prompt_git_in_git_dir 001
  __init_color prompt_git_branch 002
  __init_color prompt_git_branch_detached 009
  __init_color prompt_git_merge_behind 228
  __init_color prompt_git_merge_ahead 135
  __init_color prompt_git_staged 010
  __init_color prompt_git_unstaged 196
  __init_color prompt_git_untracked 011
  __init_color prompt_git_invalid 009
  __init_color prompt_git_stashed 039
  __init_color prompt_git_operation 196
  __init_color prompt_git_upstream 039
  __init_color prompt_git_upstream_behind 228
  __init_color prompt_git_upstream_ahead 135
  __init_color prompt_git_unmerged 011
  __init_color prompt_git_now 196

  __init_color prompt_color_job_cnt 045

  # PROMPT2
  __init_color prompt2_color 006

  # SPROMPT
  __init_color sprompt_color 011

  # Prevent percentage showing up if output doesn't end with a newline.
  export PROMPT_EOL_MARK=''

  if [[ ${prompt_newline} == '' ]]; then
    typeset -g prompt_newline=$'\n%{\r%}'
  fi
  if [[ ${prompt_sep} == '' ]]; then
    typeset -g prompt_sep="${prompt_git_separator_start}|${prompt_git_separator_end}"
  fi

  async

  add-zsh-hook precmd __prompt_precmd

  prompt_username=
  if [[ ${SSH_CONNECTION} != '' ]] || __is_root; then
    prompt_username+='${prompt_color_user_start}%n${prompt_color_user_end}'
  fi
  if [[ ${SSH_CONNECTION} != '' ]]; then
    prompt_username+='@${prompt_color_host_start}%m${prompt_color_host_end}'
  fi

  typeset -g prompt_symbol=$(
  echo -en '%(?.${prompt_color_symbol_start}.${prompt_color_symbol_error_start})'
  echo -en '%#'
  echo -en '%(?.${prompt_color_symbol_end}.${prompt_color_symbol_error_end})'
  )

  PROMPT2='${prompt2_color_start}(%_)>${prompt2_color_end} '
  SPROMPT='${sprompt_color_start}%r is correct?${sprompt_color_end} [%Uy%ues/%UN%uo/%Ua%ubort/%Ue%udit]:'
}
# }}}

function __prompt_precmd() # {{{
{
  __prompt_async_tasks

  # print the preprompt
  __prompt_preprompt_render 'precmd'
}
# }}}

function __prompt_async_tasks() # {{{
{
  setopt localoptions noshwordsplit

  # initialize async worker
  if ! ${prompt_async_init:-false}; then
    async_start_worker 'prompt' -u -n
    async_register_callback 'prompt' __prompt_async_callback
    typeset -g prompt_async_init=true
  fi

  typeset -gA prompt_git_info

  local -H MATCH MBEGIN MEND
  if [[ ${prompt_git_info[pwd]} == '' || ${PWD} != ${prompt_git_info[pwd]}* ]]; then
    # stop any running async jobs
    async_flush_jobs 'prompt'

    unset prompt_git_repo
    unset prompt_git_dirty
    unset prompt_git_upstream
    unset prompt_git_now_stash
    prompt_git_info[top]=
    prompt_git_info[git_dir]=
  fi
  unset MATCH MBEGIN MEND

  async_job 'prompt' __prompt_async_git_info ${PWD}

  if [[ ${prompt_git_info[git_dir]} == '' ]]; then
    return
  fi

  __prompt_async_refresh
}
# }}}

function __prompt_async_refresh() # {{{
{
  setopt localoptions noshwordsplit

  async_job 'prompt' __prompt_async_git_repo ${PWD} ${prompt_git_info[git_dir]}
  async_job 'prompt' __prompt_async_git_dirty ${PWD}
  async_job 'prompt' __prompt_async_git_upstream ${PWD}
  async_job 'prompt' __prompt_async_git_now_stash ${PWD}
}
# }}}

function __prompt_async_git_repo() { # {{{
  setopt localoptions noshwordsplit
  local _dir=${1}

  # use cd -q to avoid side effects of changing directory, e.g. chpwd hooks
  builtin cd -q ${_dir}

  local -A _res
  local _git_dir=${2}

  local _repo
  _repo=( $(command git rev-parse --is-inside-git-dir --is-bare-repository HEAD 2>/dev/null) )

  _res[is_inside_gitdir]=${_repo[1]}
  _res[is_bare]=${_repo[2]}
  _res[sha]=${_repo[3]}

  local -A _op_branch_detached
  _op_branch_detached=("${(Q@)${(z)$(__get_op_branch_detached "${_git_dir}" "${_res[sha]}")}}")
  _res[operation]=${_op_branch_detached[operation]}
  _res[branch]=${_op_branch_detached[branch]}
  _res[is_detached]=${_op_branch_detached[detached]}


  # unmerged
  local _counts
  _counts=( $(command git rev-list --count --left-right master...HEAD 2>/dev/null) )

  if [[ ${#_counts} == 0 ]]; then
    _res[behind]=0
    _res[ahead]=0
  else
    _res[behind]=${_counts[1]}
    _res[ahead]=${_counts[2]}
  fi

  print -r - "${(@kvq)_res}"
}
# }}}

function __get_op_branch_detached() # {{{
{
  local _git_dir=${1}
  local _sha=${2}

  local _branch=''
  local _step=-1
  local _total=-1
  local _operation=''
  local _is_detached=false

  if [[ -d ${_git_dir}/rebase-merge ]]; then
    _branch=$(cat "${_git_dir}/rebase-merge/head-name" 2>/dev/null)
    _step=$(cat "${_git_dir}/rebase-merge/msgnum" 2>/dev/null)
    _total=$(cat "${_git_dir}/rebase-merge/end" 2>/dev/null)
    if [[ -f ${_git_dir}/rebase-merge/interactive ]]; then
      _operation='REBASE-i'
    else
      _operation='REBASE-m'
    fi
  else
    if [[ -d ${_git_dir}/rebase-apply ]]; then
      _step=$(cat "${_git_dir}/rebase-apply/next" 2>/dev/null)
      _total=$(cat "${_git_dir}/rebase-apply/last" 2>/dev/null)
      if [[ -f ${_git_dir}/rebase-apply/rebasing ]]; then
        _branch=$(cat "${_git_dir}/rebase-apply/head-name" 2>/dev/null)
        _operation='REBASE'
      elif [[ -f ${_git_dir}/rebase-apply/applying ]]; then
        _operation='AM'
      else
        _operation='AM/REBASE'
      fi
    elif [[ -f ${_git_dir}/MERGE_HEAD ]]; then
      _operation='MERGING'
    elif [[ -f ${_git_dir}/CHERRY_PICK_HEAD ]]; then
      _operation='CHERRY-PICKING'
    elif [[ -f ${_git_dir}/REVERT_HEAD ]]; then
      _operation='REVERTING'
    elif [[ -f ${_git_dir}/BISECT_LOG ]]; then
      _operation='BISECTING'
    fi
  fi

  if [[ ${_step} -ge 0 && ${_total} -ge 0 ]]; then
    _operation="${_operation} ${_step}/${_total}"
  fi

  if [[ ${_branch} == '' ]]; then
    _branch=$(command git symbolic-ref HEAD 2>/dev/null)
    if [[ ${?} != 0 ]]; then
      _is_detached=true
      _branch=$(command git describe --contains --all HEAD 2>/dev/null)
      if [[ ${?} != 0 ]]; then
        if [[ ${_sha} != '' ]]; then
          _branch=${_sha[0,8]}
        else
          _branch=''
        fi
      fi
    fi
  fi

  local -A _res
  _res[branch]=${_branch#refs/heads/}
  _res[operation]=${_operation}
  _res[detached]=${_is_detached}

  print -r - ${(@kvq)_res}
}
# }}}

function __prompt_async_git_dirty() { # {{{
  setopt localoptions noshwordsplit
  local _dir=${1}

  # use cd -q to avoid side effects of changing directory, e.g. chpwd hooks
  builtin cd -q ${_dir}

  local _status
  _status=("${(f)$(command git status --porcelain --ignore-submodules -unormal 2>/dev/null)}")
  local _ret=${?}
  if [[ ${_ret} == 0 && ${#_status} > 0 && ${_status[1]} != '' ]]; then
    local _untracked=${(M)#_status:#\?\? *}
    local _staged=${(M)#_status:#?  *}
    local _unstaged=${(M)#_status:# ? *}
    local _invalid=$(( ${#_status} - ${_untracked} - ${_staged} - ${_unstaged} ))

    print -- ${_staged} ${_unstaged} ${_untracked} ${_invalid}
  fi

  return ${_ret}
}
# }}}

function __prompt_async_git_upstream() { # {{{
  setopt localoptions noshwordsplit
  local _dir=${1}

  # use cd -q to avoid side effects of changing directory, e.g. chpwd hooks
  builtin cd -q ${_dir}

  local -A _res
  _res[upstream]=
  _res[behind]=0
  _res[ahead]=0

  local _counts
  _counts=( $(command git rev-list --count --left-right '@{upstream}'...HEAD 2>/dev/null) )
  if [[ ${?} != 0 ]]; then
    print -r - "${(@kvq)_res}"
    return
  fi

  if [[ ${#_counts} != 0 ]]; then
    _res[behind]=${_counts[1]}
    _res[ahead]=${_counts[2]}

    _res[upstream]=$(command git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)
  fi

  print -r - "${(@kvq)_res}"
}
# }}}

function __prompt_async_git_now_stash() { # {{{
  setopt localoptions noshwordsplit
  local _dir=${1}

  # use cd -q to avoid side effects of changing directory, e.g. chpwd hooks
  builtin cd -q ${_dir}

  local _stash=$(command git stash list | grep -c '')
  if [[ ${?} != 0 ]]; then
    _stash=0
  fi

  local _now=0
  if (( ${+commands[git-now]} )); then
    _now=$(command git now grep | grep -c '')
    if [[ ${?} != 0 ]]; then
      _now=0
    fi
  fi

  print -- ${_stash} ${_now}
}
# }}}

function __prompt_async_callback() # {{{
{
  setopt localoptions noshwordsplit

  local _job=${1}
  local _code=${2}
  local _output=${3}
  local _exec_time=${4}
  local _next_pending=${6}
  local _do_render=false

  case ${_job} in
    __prompt_async_git_info)
      typeset -gA prompt_git_info

      if [[ ${_output} == '' ]]; then
        prompt_git_info[top]=
        prompt_git_info[git_dir]=
      else
        # parse output (z) and unquote as array (Q@)
        local -A _info
        _info=("${(Q@)${(z)_output}}")
        local -H MATCH MBEGIN MEND
        if [[ ${_info}[top] == ${prompt_git_info}[top] ]]; then
          if [[ ${prompt_git_info[pwd]} == ${PWD}* ]]; then
            prompt_git_info[pwd]=${PWD}
          fi
        else
          prompt_git_info[pwd]=${PWD}
        fi
        unset MATCH MBEGIN MEND

        if [[ ${_info[git_dir]} != '' ]]; then
          __prompt_async_refresh
        fi

        # always update .git dir and toplevel
        prompt_git_info[top]=${_info[top]}
        prompt_git_info[git_dir]=${_info[git_dir]}
      fi

      _do_render=true
      ;;
    __prompt_async_git_repo)
      local _prev_repo=${prompt_git_repo}
      if [[ ${_output} == '' ]]; then
        unset prompt_git_repo
      else
        local -A _repo
        _repo=("${(Q@)${(z)_output}}")

        local _branch_prefix
        if ${_repo[is_bare]}; then
          _branch_prefix="${prompt_git_bare_repo_start}BARE:${prompt_git_bare_repo_end}"
        elif ${_repo[is_inside_gitdir]}; then
          _branch_prefix="${prompt_git_in_git_dir_start}GIT:${prompt_git_in_git_dir_end}"
        else
          _branch_prefix="$(echo -e "\uf126")"
        fi

        local _branch
        if ${_repo[is_detached]}; then
          _branch="${prompt_git_branch_detached_start}${_repo[branch]}${prompt_git_branch_detached_end}"
        else
          _branch="${prompt_git_branch_start}${_repo[branch]}${prompt_git_branch_end}"
        fi

        local _operation
        if [[ ${_repo[operation]} != '' ]]; then
          _operation=" <${prompt_git_operation_start}${_repo[operation]}${prompt_git_operation_end}>"
        fi

        local _ahead=${_repo[ahead]}
        local _behind=${_repo[behind]}
        if [[ ${_ahead} > 0 ]]; then
          _ahead="${prompt_git_merge_ahead_start}$(echo -e "\uf062")${_repo[ahead]}${prompt_git_merge_ahead_end}"
        else
          _ahead=
        fi
        if [[ ${_behind} > 0 ]]; then
          _behind="${prompt_git_merge_behind_start}$(echo -e "\uf063")${_repo[behind]}${prompt_git_merge_behind_end}"
        else
          _behind=
        fi
        typeset -g prompt_git_repo="${_behind}${_branch_prefix}${_branch}${_ahead}${_operation}"
      fi

      if [[ ${_prev_repo} != ${prompt_git_repo} ]]; then
        _do_render=true
      fi
      ;;
    __prompt_async_git_dirty)
      local _prev_dirty=${prompt_git_dirty}
      if [[ ${_output} == '' ]]; then
        unset prompt_git_dirty
      else
        local _staged
        local _unstaged
        local _untracked
        local _invalid

        echo "${_output}" | read _staged _unstaged _untracked _invalid

        if [[ ${_staged} > 0 ]]; then
          _staged="${prompt_git_staged_start}$(echo -e "\uf00c")${prompt_git_staged_end}"
        else
          _staged=
        fi
        if [[ ${_unstaged} > 0 ]]; then
          _unstaged="${prompt_git_unstaged_start}$(echo -e "\uf069")${prompt_git_unstaged_end}"
        else
          _unstaged=
        fi
        if [[ ${_untracked} > 0 ]]; then
          _untracked="${prompt_git_untracked_start}$(echo -e "\uf067")${prompt_git_untracked_end}"
        else
          _untracked=
        fi
        if [[ ${_invalid} > 0 ]]; then
          _invalid="${prompt_git_invalid_start}$(echo -e "\uf00d")${prompt_git_invalid_end}"
        else
          _invalid=
        fi
        typeset -g prompt_git_dirty="${_staged}${_unstaged}${_untracked}${_invalid}"
      fi

      if [[ ${_prev_dirty} != ${prompt_git_dirty} ]]; then
        _do_render=true
      fi
      ;;
    __prompt_async_git_upstream)
      local _prev_upstream=${prompt_git_upstream}
      if [[ ${_output} == '' ]]; then
        unset prompt_git_upstream
      else
        local -A _up
        _up=("${(Q@)${(z)_output}}")

        local _upstream
        local _ahead
        local _behind
        if [[ ${_up[upstream]} != '' ]]; then
          _upstream="${prompt_git_upstream_start}${_up[upstream]}${prompt_git_upstream_end}"
        else
          _upstream=
        fi
        if [[ ${_up[ahead]} > 0 ]]; then
          _ahead="${prompt_git_upstream_ahead_start}$(echo -e "\uf062")${_up[ahead]}${prompt_git_upstream_ahead_end}"
        else
          _ahead=
        fi
        if [[ ${_up[behind]} > 0 ]]; then
          _behind="${prompt_git_upstream_behind_start}$(echo -e "\uf063")${_up[behind]}${prompt_git_upstream_behind_end}"
        else
          _behind=
        fi
        typeset -g prompt_git_upstream="${_behind}${_upstream}${_ahead}"
      fi

      if [[ ${_prev_upstream} != ${prompt_git_upstream} ]]; then
        _do_render=true
      fi
      ;;
    __prompt_async_git_now_stash)
      local _prev_now_stash=${prompt_git_now_stash}
      if [[ ${_output} == '' ]]; then
        unset prompt_git_now_stash
      else
        local _stash
        local _now

        echo "${_output}" | read _stash _now

        if [[ ${_stash} > 0 ]]; then
          _stash="${prompt_git_stashed_start}$(echo -e "\uf155")${_stash}${prompt_git_stashed_end}"
        else
          _stash=
        fi
        if [[ ${_now} > 0 ]]; then
          _now="${prompt_git_now_start}$(echo -e "\uf017")${_now}${prompt_git_now_end}"
        else
          _now=
        fi
        typeset -g prompt_git_now_stash="${_now}${_stash}"
      fi

      if [[ ${_prev_now_stash} != ${prompt_git_now_stash} ]]; then
        _do_render=true
      fi
      ;;
    *)
      ;;
  esac

  if (( _next_pending )); then
    if ${_do_render}; then
      typeset -g prompt_async_render_requested=true
      return
    fi
  fi

  if ${prompt_async_render_requested:-${_do_render}}; then
    __prompt_preprompt_render
  fi
  unset prompt_async_render_requested
}
# }}}

function __prompt_async_git_info() # {{{
{
  if ! (( ${+commands[git]} )); then
    return
  fi

  setopt localoptions noshwordsplit
  builtin cd -q ${1} 2>/dev/null

  local _repo
  _repo=( $(command git rev-parse --git-dir --show-toplevel 2>/dev/null) )
  if [[ ${?} != 0 ]]; then
    return
  fi

  local -A _info
  _info[git_dir]=$(readlink -f "${_repo[1]}")
  _info[top]=${_repo[2]}

  print -r - ${(@kvq)_info}
}
# }}}

function __prompt_preprompt_render() # {{{
{
  setopt localoptions noshwordsplit

  local -a _preprompt_parts

  _preprompt_parts+=('${prompt_color_cwd_start}%~${prompt_color_cwd_end}')

  # git status info
  typeset -gA prompt_git_info
  local -a _git_info_parts
  if [[ ${prompt_git_info[git_dir]} != '' ]]; then
    _git_info_parts+=('${prompt_git_repo}')
    if [[ ${prompt_git_now_stash} != '' ]]; then
      _git_info_parts+=('${prompt_git_now_stash}')
    fi
    if [[ ${prompt_git_dirty} != '' ]]; then
      _git_info_parts+=('${prompt_git_dirty}')
    fi
    if [[ ${prompt_git_upstream} != '' ]]; then
      _git_info_parts+=('${prompt_git_upstream}')
    fi
  fi

  if [[ ${#_git_info_parts} > 0 ]]; then
    _preprompt_parts+=("(${(j.${prompt_sep}.)_git_info_parts})")
  fi

  local -ah _ps1
  _ps1=(
  ${prompt_newline}
  ${(j. .)_preprompt_parts}
  ' %(1j,${prompt_color_job_cnt_start}[%j]${prompt_color_job_cnt_end},)'
  ${prompt_newline}
  "${prompt_username}"
  ${prompt_symbol}
  ' '
  )

  PROMPT="${(j..)_ps1}"

  local _expanded_prompt="${(S%%)PROMPT}"
  if [[ ${1} != precmd ]] && [[ ${prompt_last_prompt} != ${_expanded_prompt} ]]; then
    zle && zle .reset-prompt
  fi

  typeset -g prompt_last_prompt=${_expanded_prompt}
}
# }}}

__prompt_setup

function __slimes() # {{{
{
  local _dir=${1}

  if [[ ! -d ${_dir} ]]; then
    return
  fi

  # https://github.com/dot-motd/dragon-quest

  # ランダムで値を取得(0〜99の範囲)
  readonly n=$((RANDOM % 100))

  if [[ ${n} -lt 40 ]]; then
    # スライム 40%
    cat "${_dir}/slime.txt"
  elif [[ ${n} -lt 65 ]]; then
    # スライムベス 25%
    cat "${_dir}/slime-beth.txt"
  elif [[ ${n} -lt 85 ]]; then
    # バブルスライム 20%
    cat "${_dir}/bubble-slime.txt"
  elif [[ ${n} -lt 95 ]]; then
    # メタルスライム 10%
    cat "${_dir}/metal-slime.txt"
  elif [[ ${n} -lt 99 ]]; then
    # はぐれメタル 4%
    cat "${_dir}/hagure-metal.txt"
  elif [[ ${n} -eq 99 ]]; then
    # オールスター 1%
    cat "${_dir}/slime-allstar.txt"
  fi
}
# }}}

__slimes "${0:a:h}/slimes"
