if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif

setlocal shiftwidth=2
setlocal iskeyword+=-

let b:undo_ftplugin .= 'setlocal shiftwidth< iskeyword<'
