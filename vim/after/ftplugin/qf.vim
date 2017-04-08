if exists('b:did_qf_ftplugin')
  finish
endif

let b:did_qf_ftplugin = 1

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'unlet! b:did_qf_ftplugin'

nnoremap <silent> <buffer> q :q<CR>
