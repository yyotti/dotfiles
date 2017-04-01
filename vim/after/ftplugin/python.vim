if exists('b:did_python_ftplugin')
  finish
endif

let b:did_python_ftplugin = 1

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal foldmethod< textwidth< smarttab< expandtab< smartindent<'
let b:undo_ftplugin .= ' | unlet! b:did_python_ftplugin'

setlocal foldmethod=indent
setlocal textwidth=80
setlocal smarttab
setlocal expandtab
setlocal nosmartindent
