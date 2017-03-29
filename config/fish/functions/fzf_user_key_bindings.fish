function fzf_user_key_bindings

  function fzf-environment-variables-widget -d "Show environment variables"
    set -l query (commandline -t)
    set query (string trim --left --chars='$' "$query")
    set -l has_daller $status

    set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
    begin
      set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS --tiebreak=index --bind=ctrl-r:toggle-sort"
      set --names $argv | eval (__fzfcmd)" -q '$query'" | read -l result
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
  # Ctrl+U
  bind -M insert \u0095 'fzf-environment-variables-widget -U'

  function fzf-ghq-widget -d "Show Git Repositories"
    set -l query (commandline -t)

    set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
    begin
      set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS --tiebreak=index --bind=ctrl-r:toggle-sort"
      ghq list --full-path | eval (__fzfcmd)" -q '$query'" | read -l result
      if [ -n "$result" ]
        commandline -t "$result"
      end
    end

    commandline -f repaint
  end

  bind -M insert \cg fzf-ghq-widget
end

# vim:set sw=2:
