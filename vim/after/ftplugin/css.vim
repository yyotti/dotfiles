if exists('b:did_css_ftplugin')
  finish
endif

let b:did_css_ftplugin = 1

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal iskeyword<'
let b:undo_ftplugin .= ' | unlet! b:did_css_ftplugin'

setlocal iskeyword+=-
setlocal iskeyword-=#
