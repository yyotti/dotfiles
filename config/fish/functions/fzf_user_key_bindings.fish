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

  bind -M insert \cx fzf-environment-variables-widget

  function fzf-ghq-widget -d "Show GHQ Repositories"
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

  function fzf-vim-plugins-widget -d "Show installed Vim plugins"
    set -l query (commandline -t)

    set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
    begin
      set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS --tiebreak=index --bind=ctrl-r:toggle-sort"
      find ~/.vim/pack/bundle/opt -maxdepth 1 -type d | eval (__fzfcmd)" -q '$query'" | read -l result
      if [ -n "$result" ]
        commandline -t "$result"
      end
    end

    commandline -f repaint
  end

  # Ctrl+V
  bind -M insert \cv fzf-vim-plugins-widget
end

# vim:set sw=2:
