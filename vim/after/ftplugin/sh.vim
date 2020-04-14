if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif
let s:undo = []

if !has_key(g:plugs, 'editorconfig-vim')
  setlocal shiftwidth=2
  call add(s:undo, 'setlocal shiftwidth<')
endif

if !empty(s:undo)
  let b:undo_ftplugin .= join(s:undo, '|')
endif
