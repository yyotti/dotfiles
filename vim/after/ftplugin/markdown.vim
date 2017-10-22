if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif

let b:del_last_whitespaces = 0

setlocal colorcolumn=
setlocal wrap

let b:undo_ftplugin .= 'setlocal colorcolumn< wrap<'
let b:undo_ftplugin .= '|unlet! b:del_last_whitespaces'
