##############################################################################
# zinit
#
declare -A ZINIT
ZINIT[HOME_DIR]=${XDG_CACHE_HOME}/zsh/zinit
ZINIT[BIN_DIR]=${ZINIT[HOME_DIR]}/bin
ZINIT[PLUGINS_DIR]=${ZINIT[HOME_DIR]}/plugins
ZINIT[COMPLETIONS_DIR]=${ZINIT[HOME_DIR]}/completions
ZINIT[SNIPPETS_DIR]=${ZINIT[HOME_DIR]}/snippets

export ZINIT

if [[ ! -d "${ZINIT[BIN_DIR]}" ]]; then
  ZINIT_HOME="${ZINIT[HOME_DIR]}" \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
fi
__zcompile "${ZINIT[BIN_DIR]}/zinit.zsh" && source "${ZINIT[BIN_DIR]}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# plugins
zinit wait lucid atload"zicompinit; zicdreplay" blockf for zsh-users/zsh-completions
zinit load 'mafredri/zsh-async'
zinit light 'zdharma/fast-syntax-highlighting'
zinit light 'zsh-users/zsh-autosuggestions'

# Setup time {{{
ZSH_COMMAND_TIME_MIN_SECONDS=3
ZSH_COMMAND_TIME_MSG='** Execution time: %s sec **'
ZSH_COMMAND_TIME_COLOR=cyan
# }}}
