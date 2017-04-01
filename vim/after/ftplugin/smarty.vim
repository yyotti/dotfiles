if exists('b:did_smarty_ftplugin')
  finish
endif

let b:did_smarty_ftplugin = 1

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal colorcolumn< wrap<'
let b:undo_ftplugin .= ' | unlet! b:did_smarty_ftplugin'

setlocal colorcolumn=
setlocal nowrap
