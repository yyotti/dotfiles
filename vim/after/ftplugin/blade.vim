if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif
let s:undo = []

let b:caw_wrap_oneline_comment = [ '{{--', '--}}' ]
call add(s:undo, 'unlet! b:caw_wrap_oneline_comment')

if !empty(s:undo)
  let b:undo_ftplugin .= join(s:undo, '|')
endif
