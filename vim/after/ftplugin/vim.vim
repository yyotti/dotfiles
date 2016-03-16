"-----------------------------------------------------------------------------
" vim.vim:
"
let s:save_cpo = &cpoptions
set cpoptions&vim

setlocal commentstring=\ \"%s

let &cpoptions = s:save_cpo
unlet s:save_cpo
