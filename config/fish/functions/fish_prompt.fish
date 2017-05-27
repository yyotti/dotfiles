function fish_prompt --description 'Write out the prompt'
    set -l color_cwd
    set -l color_user
    set -l suffix
    switch $USER
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            if set -q fish_color_user_root
                set color_user $fish_color_user_root
            else
                set color_user $fish_color_user
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set color_user $fish_color_user
            set suffix '%'
    end

    echo -n -s [
    echo -n -s (set_color $color_user) "$USER" (set_color $fish_color_normal)
    echo -n -s @
    echo -n -s (set_color $fish_color_host) (prompt_hostname) (set_color $fish_color_normal)
    echo -n -s :
    echo -n -s (set_color $color_cwd) (prompt_pwd) (set_color $fish_color_normal)
    echo -n -s ]
    echo -n -s (__fish_vcs_prompt)
    echo ""
    echo "$suffix "
end
