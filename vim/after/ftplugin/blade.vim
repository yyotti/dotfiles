if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif

let b:caw_wrap_oneline_comment = [ '{{--', '--}}' ]

let b:undo_ftplugin .= 'unlet! b:caw_wrap_oneline_comment'
