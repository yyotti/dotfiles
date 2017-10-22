if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif

setlocal iskeyword+=:
setlocal iskeyword+=#
setlocal iskeyword+=-

nnoremap <silent> <buffer> q :q<CR>

let b:undo_ftplugin .= 'setlocal iskeyword<|unmap <buffer> q'
