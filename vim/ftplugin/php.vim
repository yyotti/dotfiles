scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal colorcolumn=
setlocal nowrap

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set foldmethod=marker:

