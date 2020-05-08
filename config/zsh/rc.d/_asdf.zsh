##############################################################################
# asdf
#
_asdf_zsh="${HOMEBREW_PREFIX}/opt/asdf/asdf.sh"
if [[ -e ${_asdf_zsh} ]]; then
  source "${_asdf_zsh}"

  fpath=(${ASDF_DIR}/completions(N-/) ${fpath})
fi
