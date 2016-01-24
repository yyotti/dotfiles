scriptencoding utf-8
"-----------------------------------------------------------------------------
" vim.vim:
"
let s:save_cpo = &cpo
set cpo&vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin = ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal modeline<'

setlocal shiftwidth=2
setlocal softtabstop=2

" gfで関数名から定義ファイルを開く
let &l:path = join(map(split(&runtimepath, ','), 'v:val."/autoload"'), ',')
setlocal suffixesadd=.vim
setlocal includeexpr=fnamemodify(substitute(v:fname,'#','/','g'),':h')

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set foldmethod=marker:
