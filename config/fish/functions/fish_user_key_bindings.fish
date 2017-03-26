function fish_user_key_bindings -d 'Custom key bindings'
    # Use vi mode
    fish_vi_key_bindings

    # fzf key binding
    if functions -q fzf_key_bindings
        fzf_key_bindings

        function fzf-bind-widget -d "Show key bindings"
            set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
            begin
                set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS +m"
                bind | eval (__fzfcmd) -q '(commandline)' | read -l result
                and commandline -- $result
            end
            commandline -f repaint
        end

        # fzf
        bind \eb fzf-bind-widget
        bind -M insert \eb fzf-bind-widget
    end

    # cursor moving
    bind -M insert \cf forward-char
    bind -M insert \cb backward-char
    bind -M insert \ca beginning-of-line
    bind -M insert \ce end-of-line

    # history
    for mode in default insert
        bind -M $mode \cp history-search-backward
        bind -M $mode \cn history-search-forward
    end
end
