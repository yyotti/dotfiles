"-----------------------------------------------------------------------------
" For Windows:
"
if $PATH !~? '\(^(\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

" Disable error messages.
let g:CSApprox_verbose_level = 0
