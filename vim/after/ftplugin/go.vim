if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif

setlocal tabstop=4

let b:del_last_whitespaces = 0

if pack#has('fatih/vim-go')
  nnoremap <silent> <buffer> <LocalLeader>t :<C-u>GoTest<CR>
  nnoremap <silent> <buffer> <LocalLeader>r :<C-u>GoRename<CR>
  nnoremap <silent> <buffer> <LocalLeader>d :<C-u>GoDef<CR>
  nnoremap          <buffer> <LocalLeader>i :<C-u>GoImport
  nnoremap <silent> <buffer> <LocalLeader>I :<C-u>GoImports<CR>
endif

let b:undo_ftplugin .= 'setlocal tabstop<'
let b:undo_ftplugin .= '|unlet! b:del_last_whitespaces'
