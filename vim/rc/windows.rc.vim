"-----------------------------------------------------------------------------
" For Windows:
"
if $PATH !~? '\(^(\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

" TODO Search path
set pythonthreedll=python36.dll

" Disable error messages.
let g:CSApprox_verbose_level = 0
