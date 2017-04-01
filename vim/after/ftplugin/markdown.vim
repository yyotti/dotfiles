if exists('b:did_markdown_ftplugin')
  finish
endif

let b:did_markdown_ftplugin = 1

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal colorcolumn< wrap< | unlet! b:not_del_last_whitespaces'
let b:undo_ftplugin .= ' | unlet! b:did_markdown_ftplugin'

let b:not_del_last_whitespaces = 1

setlocal colorcolumn=
setlocal wrap
