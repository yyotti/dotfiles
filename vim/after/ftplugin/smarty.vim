if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif
let s:undo = []

" setlocal colorcolumn=
setlocal nowrap
call add(s:undo, 'setlocal nowrap<')

if !empty(s:undo)
  let b:undo_ftplugin .= join(s:undo, '|')
endif
