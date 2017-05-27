# TODO Check login shell
# TODO Check interactive shell

#=============================================================================
# PATH
#
set -x GOPATH "$HOME/.go"

function __add_user_paths
    for path in $argv
        set path (readlink -f $path)

        test -d $path
        and not contains $path $fish_user_paths
        and set fish_user_paths $fish_user_paths $path
    end
end

__add_user_paths \
    $HOME/bin \
    $GOPATH/bin \
    $HOME/.composer/vendor/bin

if test -d /usr/local/go/bin
    __add_user_paths /usr/local/go/bin
end

functions -e __add_user_paths

#=============================================================================
# TERM
#
if not set -q TMUX
    set -x TERM xterm-256color
end

#=============================================================================
# EDITOR
#
if command -s vim > /dev/null
    set -x EDITOR vim
end

#=============================================================================
# 日本語関係
#
set -x LANG ja_JP.UTF-8
set -x LESSCHARSET utf-8
set -x JLESSCHARSET japanese-utf-8
set -x MANPAGER "less -isr"

#=============================================================================
# Prompt
#
# パスを短縮しない
set fish_prompt_pwd_dir_length 0

#-----------------------------------------------------------------------------
# Gitリポジトリ情報
#
# Dirtyを表示
set __fish_git_prompt_showdirtystate 1
set __fish_git_prompt_char_dirtystate '+'
set __fish_git_prompt_char_stagedstate '*'
set __fish_git_prompt_char_untrackedfiles '?'
# Untrackedを表示
set __fish_git_prompt_showuntrackedfiles 1
# Stashを表示
set __fish_git_prompt_showstashstate 1
# Upstreamとの関係を表示
set __fish_git_prompt_showupstream informative
set __fish_git_prompt_char_upstream_behind '-'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_diverged '!'
# 状態に色をつける
set __fish_git_prompt_showcolorhints 1
set __fish_git_prompt_color_flags yellow
# branchと状態のセパレータ
set __fish_git_prompt_char_stateseparator '|'
# 状態とUpstreamのセパレータ
set __fish_git_prompt_char_upstream_prefix '|'

#=============================================================================
# Colors
#
set -e fish_color_cwd_root
set fish_color_autosuggestion 808080
set fish_color_command ffaf00
set fish_color_comment 9e9e9e
set fish_color_end 268bd2
set fish_color_error brred --bold
set fish_color_escape bryellow
set fish_color_history_current green
set fish_color_host brblue
set fish_color_param ffffff
set fish_color_quote 00ffd7
set fish_color_redirection 6c71c4
set fish_color_user cyan
set fish_color_user_root brred

#=============================================================================
# fresco
#
if status -i;
    if not functions -q fresco
        curl https://raw.githubusercontent.com/masa0x80/fresco/master/install | fish
        source $HOME/.config/fish/conf.d/fresco.fish
    end

    # if functions -q fresco
    #     if not functions -q z
    #         fresco fisherman/z
    #     end
    # end
end

#=============================================================================
# tmux
#
if status -i; and command -s tmux > /dev/null; and not set -q TMUX
    set -l id (tmux list-sessions ^ /dev/null)
    if test -z "$id"
        env SHELL=(which fish ^ /dev/null) tmux new-session
    else
        # TODO Check fzf,peco,percol,...
        set -l create_new_session "Create New Session"
        set id $id "$create_new_session:"
        set -l selected_id (for i in $id; echo $i; end | fzf | cut -d: -f1)
        if test "$selected_id" = "$create_new_session"
            env SHELL=(which fish ^ /dev/null) tmux new-session
        else
            if test -n "$selected_id"
                env SHELL=(which fish ^ /dev/null) tmux attach-session -t "$selected_id"
            else
                # Start normally
            end
        end
    end
end
