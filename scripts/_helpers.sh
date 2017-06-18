#!/usr/bin/env bash

function on-error() # {{{
{
  local _status=$?
  local _script=$0
  local _line=$1
  shift

  local _args=
  for _i in "$@"; do
    _args+="\"$_i\" "
  done

  cat <<_EOM_ >&2

--------------------------------------------------
Error occured on $_script [Line $_line]: Status $_status

Status: $_status
Commandline: $_script $_args
--------------------------------------------------

_EOM_
}
# }}}

function echoe()
{
  echo "$@" >&2
}

