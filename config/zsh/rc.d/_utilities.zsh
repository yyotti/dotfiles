##############################################################################
# Utility functions
#

function __is_wsl()
{
  [[ $(uname -a) =~ Linux && $(uname -a) =~ Microsoft ]]
}

if (( ${+commands[nkf]} )); then
  function urlenc()
  {
    echo "${1}" | nkf -wWMQ | tr = %
  }
  function urldec()
  {
    echo "${1}" | nkf -w --url-input
  }
fi

# 256色のカラーコードを表示する
function listcolors()
{
  echo 'standard colors:'
  for c in {000..015}; do
    echo -n "\e[38;5;${c}m ${c}\e[0m"
    [[ $((c%6)) == 5 ]] && echo
  done
  echo

  echo

  echo '256 colors:'
  for c in {016..255}; do
    echo -n "\e[38;5;${c}m ${c}\e[0m"
    [[ $(($((c-16))%6)) == 5 ]] && echo
  done
  echo
}
