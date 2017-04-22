if exists('b:did_sh_ftplugin')
  finish
endif

let b:did_sh_ftplugin = 1

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal shiftwidth<'
let b:undo_ftplugin .= ' | unlet! b:did_sh_ftplugin'

setlocal shiftwidth=2
