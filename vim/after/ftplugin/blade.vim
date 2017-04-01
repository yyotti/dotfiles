if exists('b:did_blade_ftplugin')
  finish
endif

let b:did_blade_ftplugin = 1

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'unlet! b:caw_wrap_oneline_comment'
let b:undo_ftplugin .= ' | unlet! b:did_blade_ftplugin'

let b:caw_wrap_oneline_comment = [ '{{--', '--}}' ]
