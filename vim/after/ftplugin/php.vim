if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif

setlocal colorcolumn=
setlocal nowrap

let b:undo_ftplugin .= 'setlocal colorcolumn< wrap<'
