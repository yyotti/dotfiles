if exists('b:did_go_ftplugin')
  finish
endif

let b:did_go_ftplugin = 1

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal tabstop<'
let b:undo_ftplugin .= ' | unlet! b:did_go_ftplugin'

highlight default link goErr WarningMsg
match goErr /\<err\>/

setlocal tabstop=4
