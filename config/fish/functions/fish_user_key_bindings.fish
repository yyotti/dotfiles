function fish_user_key_bindings -d 'Custom key bindings'
    # Use vi mode
    fish_vi_key_bindings

    # disable bindings
    bind -e -M insert \cv
    bind -e -M insert \cx

    # fzf key binding
    if functions -q fzf_key_bindings; and command -s fzf > /dev/null
        set -g FZF_TMUX 1
        set -g FZF_CTRL_T_COMMAND "command find -L \$dir -mindepth 1 -path \$dir'*/\\.*' -prune -o -type f -print -o -type d -print -o -type l -print 2> /dev/null"
        set -g FZF_ALT_C_COMMAND "command find -L . -mindepth 1 -path '*/\\.*' -prune -o -type d -print 2> /dev/null"

        fzf_key_bindings
        fzf_user_key_bindings
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
