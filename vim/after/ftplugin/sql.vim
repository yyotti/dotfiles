if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif
let s:undo = []

if executable('sql-formatter')
  setlocal formatexpr=
  setlocal formatprg=sql-formatter
  call add(s:undo, 'setlocal formatexpr< formatprg<')
endif

if !empty(s:undo)
  let b:undo_ftplugin .= join(s:undo, '|')
endif
