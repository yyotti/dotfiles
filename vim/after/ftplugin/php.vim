if exists('b:did_php_ftplugin')
  finish
endif

let b:did_php_ftplugin = 1

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal colorcolumn< wrap<'
let b:undo_ftplugin .= ' | unlet! b:did_php_ftplugin'

setlocal colorcolumn=
setlocal nowrap
