if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif

setlocal iskeyword+=-
setlocal iskeyword-=#

let b:undo_ftplugin .= 'setlocal iskeyword<'
