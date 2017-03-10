let s:save_cpo = &cpoptions
set cpoptions&vim

" FIXME
" setlocal shiftwidth=2
" setlocal iskeyword+=-

let &cpoptions = s:save_cpo
unlet s:save_cpo
