scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

setlocal commentstring=\ \"%s

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set foldmethod=marker:
