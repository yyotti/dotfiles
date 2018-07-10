#!/usr/bin/env bash

# XDG Base Directory
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-${HOME}/.config}
export ZDOTDIR=${XDG_CONFIG_HOME}/zsh

# Global variables
readonly dotfiles_dir="$(cd "$(dirname "$(readlink "${BASH_SOURCE:-$0}" || echo "${BASH_SOURCE:-$0}")")/../" && pwd -P)"
readonly symlink_dir="${HOME}"

set -eu

source "${dotfiles_dir}/scripts/_helpers.sh"

# Script version
version='1.0.0'

# Symlink targets
symlink_targets=(
  config/powerline
  config/git
  config/stylelint
  config/tmux
  config/tig
  config/tslint
  config/zsh
  config/vint
  vim
  zshenv
)

# Default options
verbose=false
interactive=false
skip=true

# Helper functions {{{

usage() # {{{
{
  cat <<_EOM_ >&${1:-1}
Usage: ${0##*/} [OPTIONS] COMMAND

Options:
  -h, --help            Show this message.
  -V, --version         Show script version.
  -v, --verbose         Show verbose message.
  -i, --interactive     Show confirm
                          when already exists.(install)
                          when file is not symlink.(uninstall)
  -s, --skip (default)  Skip process
                          when already exists.(install)
                          when file is not symlink.(uninstall)
  -f, --force           Force
                          override when already exists.(install)
                          delete when file is not symlink.(uninstall)

Commands: install, uninstall
_EOM_
}
# }}}

function __err() # {{{
{
  echo "[Error] $1" >&2
}
# }}}

function __warn() # {{{
{
  echo "[Warning] $1" >&2
}
# }}}

function __confirm() # {{{
{
  local _msg=$1
  local _default=${2:-n}

  if [[ ${_default^^} == 'Y' ]]; then
    local _yn="[Y/n]"
  else
    local _yn="[y/N]"
  fi

  read -p "${_msg} ${_yn}" _ans
  [[ ${_ans} == '' && ${_default^^} == 'Y' ]] && _ans='Y'
  case "${_ans^^}" in
    YES|Y)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}
# }}}

function __verbose() # {{{
{
  if ${verbose}; then
    echo "${1:-''}"
  fi
}
# }}}

function __mklink() # {{{
{
  local _from=$1
  local _to=$2

  if [[ -e ${_to} ]]; then
    if ${skip}; then
      __verbose "Skipped: [${_to}] is already exists."
      return 0
    fi

    if ${interactive}; then
      __confirm "[${_to}] is already exists. Override?" y | true
      if [[ ${PIPESTATUS[0]} != 0 ]]; then
        __verbose "Skipped: [${_to}]"
        return 0
      fi
    fi

    rm -fr "${_to}"
  fi

  __verbose "Create symlink: [${_from}] -> [${_to}]"
  if [[ ! -d ${_to%/*} ]]; then
    mkdir -p "${_to%/*}"
  fi
  ln -s "${_from}" "${_to}"
}
# }}}

function __dellink() # {{{
{
  local _del_target=$1
  if [[ ! -e ${_del_target} ]]; then
    __verbose "Skipped: [${_del_target}] is not exists."
    return 0
  fi

  if [[ ! -L ${_del_target} ]]; then
    if ${skip}; then
      __verbose "Skipped: [${_del_target}] is not a symlink."
      return 0
    fi

    if ${interactive}; then
      __confirm "[${_del_target}] is not a symlink. Delete?" y | true
      if [[ ${PIPESTATUS[0]} != 0 ]]; then
        __verbose "Skipped: [${_del_target}]"
        return 0
      fi
    fi
  fi

  __verbose "Delete: [${_del_target}]"
  rm -fr "${_del_target}"
}
# }}}

# }}}

# Parse options {{{

params=()
for _opt in "$@"; do
  case "${_opt}" in
    -h|--help)
      usage
      exit 0
      ;;
    -V|--version)
      echo "Version ${version}"
      exit 0
      ;;
    -v|--verbose)
      verbose=true
      shift 1
      ;;
    -i|--interactive)
      interactive=true
      skip=false
      shift 1
      ;;
    -s|--skip)
      interactive=false
      skip=true
      shift 1
      ;;
    -f|--force)
      interactive=false
      skip=false
      shift 1
      ;;
    -*)
      __err "Unknown option: ${_opt}"
      usage 2
      exit 1
      ;;
    *)
      if [[ $1 != '' ]] && [[ ! $1 =~ ^-+ ]]; then
        params+=( "$1" )
        shift 1
      fi
      ;;
  esac
done

case "${#params[@]}" in
  0)
    usage 2
    exit 2
    ;;
  1)
    cmd=${params[0]}
    case "${cmd}" in
      install|uninstall)
        ;;
      *)
        __err "Unknown command: ${cmd}"
        usage 2
        exit 2
        ;;
    esac
    ;;
  *)
    __err 'Too many commands.'
    usage 2
    exit 2
    ;;
esac
# }}}

function install() # {{{
{
  for _target in "${symlink_targets[@]}"; do
    local _from="${dotfiles_dir}/${_target}"

    local _to="${_target}"
    if [[ ! ${_to} =~ ^\. ]]; then
      _to=".${_to}"
    fi
    _to="${symlink_dir}/${_to}"

    __mklink "${_from}" "${_to}"
  done

  # for zshrc
  if [[ ! -e "${ZDOTDIR}/.zshrc" ]]; then
    __mklink "${ZDOTDIR}/zshrc" "${ZDOTDIR}/.zshrc"
  fi

  # for nvim
  local _nvimdir="${XDG_CONFIG_HOME}/nvim"
  if [[ ! -e ${_nvimdir} ]]; then
    __mklink "$(readlink "${HOME}/.vim")" "${_nvimdir}"
  fi

  # for vint
  if [[ ! -e "${XDG_CONFIG_HOME}/.vintrc.yaml" ]]; then
    __mklink "${XDG_CONFIG_HOME}/vint/vintrc.yaml" "${XDG_CONFIG_HOME}/.vintrc.yaml"
  fi
}
# }}}

function uninstall() # {{{
{
  # for nvim
  __dellink "${XDG_CONFIG_HOME}/nvim"

  # for zshrc
  __dellink "${ZDOTDIR}/.zshrc"

  for _target in "${symlink_targets[@]}"; do
    local _del_target="${_target}"
    if [[ ! ${_del_target} =~ ^\..+ ]]; then
      _del_target=".${_del_target}"
    fi
    _del_target="${symlink_dir}/${_del_target}"

    __dellink "${_del_target}"
  done
}
# }}}

if [[ ${cmd} == 'install' ]]; then
  install
else
  uninstall
fi
