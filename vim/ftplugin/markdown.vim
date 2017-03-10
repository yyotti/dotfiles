let s:save_cpo = &cpoptions
set cpoptions&vim

" FIXME
" let b:not_del_last_whitespaces = 1
"
" setlocal colorcolumn=
" setlocal wrap

let &cpoptions = s:save_cpo
unlet s:save_cpo
