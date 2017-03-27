function fzf_user_key_bindings

  function fzf-environment-variables-widget -d "Show environment variables"
    set -l prefix (commandline -t)
    set prefix (string trim --left --chars='$' "$prefix")
    set -l has_daller $status
    echo $prefix

    set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
    begin
      set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS --tiebreak=index --bind=ctrl-r:toggle-sort"
      set --names $argv | eval (__fzfcmd)" -q '$prefix'" | read -l result
      if [ -z "$result" ]
        commandline -f repaint
        return
      end
      commandline -t ""
      if test $has_daller -eq 0
        commandline -i '$'
      end
      commandline -i "$result"
    end
    commandline -f repaint
  end

  bind -M insert \cv fzf-environment-variables-widget
  bind -M insert \cx 'fzf-environment-variables-widget -x'
  bind -M insert \cg 'fzf-environment-variables-widget -g'
  # Ctrl+U
  bind -M insert \u0095 'fzf-environment-variables-widget -U'
end
