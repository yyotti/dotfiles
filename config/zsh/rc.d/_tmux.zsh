##############################################################################
# tmux
#
function __init_tmux()
{
  local _tmux_conf="${XDG_CONFIG_HOME}/tmux/tmux.conf"

  local _session_ids="$(tmux -f "${_tmux_conf}" list-sessions 2>/dev/null)"
  if [[ ${_session_ids} == '' ]]; then
    tmux -f "${_tmux_conf}" new-session
  elif (( ${+commands[fzf]} )); then
    local _create_new_session="Create New Session"
    local _session_ids="${_create_new_session}:\n${_session_ids}"
    local _sel_id="$(echo "${_session_ids}" | fzf | cut -d: -f1)"
    if [[ ${_sel_id} == ${_create_new_session} ]]; then
      tmux -f "${_tmux_conf}"  new-session
    else
      if [[ ${_sel_id} != '' ]]; then
        tmux -f "${_tmux_conf}"  attach-session -t "${_sel_id}"
      else
        : # Start normally
      fi
    fi
  else
    : # Start normally
  fi
}

__init_tmux
