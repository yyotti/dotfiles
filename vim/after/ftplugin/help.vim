if exists('b:did_help_ftplugin')
  finish
endif

let b:did_help_ftplugin = 1

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal iskeyword< | silent! nunmap <buffer> q'
let b:undo_ftplugin .= ' | unlet! b:did_help_ftplugin'

setlocal iskeyword+=:
setlocal iskeyword+=#
setlocal iskeyword+=-

nnoremap <silent> <buffer> q :q<CR>
