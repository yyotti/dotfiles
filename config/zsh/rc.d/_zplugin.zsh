##############################################################################
# zplugin
#
declare -A ZPLGM
ZPLGM[HOME_DIR]=${XDG_CACHE_HOME}/zsh/zplugin
ZPLGM[BIN_DIR]=${ZPLGM[HOME_DIR]}/bin
ZPLGM[PLUGINS_DIR]=${ZPLGM[HOME_DIR]}/plugins
ZPLGM[COMPLETIONS_DIR]=${ZPLGM[HOME_DIR]}/completions
ZPLGM[SNIPPETS_DIR]=${ZPLGM[HOME_DIR]}/snippets

export ZPLGM

if [[ ! -d "${ZPLGM[BIN_DIR]}" ]]; then
  git clone https://github.com/zdharma/zplugin.git "${ZPLGM[BIN_DIR]}"
fi
__zcompile "${ZPLGM[BIN_DIR]}/zplugin.zsh" && source "${ZPLGM[BIN_DIR]}/zplugin.zsh"

# plugins
zplugin load 'zsh-users/zsh-completions'
zplugin load 'mafredri/zsh-async'
zplugin load 'zdharma/fast-syntax-highlighting'
zplugin load 'zsh-users/zsh-autosuggestions'
