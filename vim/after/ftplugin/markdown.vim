if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif
let s:undo = []

let b:del_last_whitespaces = 0
call add(s:undo, 'unlet! b:del_last_whitespaces')

setlocal colorcolumn=
setlocal wrap
call add(s:undo, 'setlocal colorcolumn< wrap<')

if exists(':ALEDisableBuffer')
  ALEDisableBuffer
endif

if !empty(s:undo)
  let b:undo_ftplugin .= join(s:undo, '|')
endif
