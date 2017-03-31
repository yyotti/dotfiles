function add-vim-plugin --description 'Add vim plugin'
    set -l vim_dir (readlink -f "$HOME/.vim")
    if test ! -d "$vim_dir"
        echo "$vim_dir" is not directory
        return 1
    end
    pushd "$vim_dir"

    for arg in $argv
        set -l url $arg
        if not string match 'https://github.com/*' "$url" > /dev/null
            set url "https://github.com/$url"
        end
        if not string match '*.git' "$url" > /dev/null
            set url "$url.git"
        end

        set repo (echo $url | sed -e 's#https://github.com/\(.*\)\.git#\1#')
        echo $repo

        git clone "$url" "pack/bundle/opt/$repo"
    end

    popd
end
