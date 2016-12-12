let s:save_cpo = &cpoptions
set cpoptions&vim

setlocal tabstop=4
setlocal softtabstop=4
setlocal colorcolumn=
setlocal nowrap

let &cpoptions = s:save_cpo
unlet s:save_cpo
