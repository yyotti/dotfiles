scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=80
setlocal expandtab
setlocal nosmartindent
setlocal foldmethod=indent

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set foldmethod=marker:
