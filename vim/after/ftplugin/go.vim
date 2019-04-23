if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif
let s:undo = []

if !has_key(g:plugs, 'editorconfig-vim')
  setlocal tabstop=4
  call add(s:undo, 'setlocal tabstop<')

  let b:del_last_whitespaces = 0
  call add(s:undo, 'unlet! b:del_last_whitespaces')
endif

if has_key(g:plugs, 'vim-go')
  nnoremap <silent> <buffer> <LocalLeader>t :<C-u>GoTest<CR>
  call add(s:undo, 'nunmap <buffer> <LocalLeader>t')

  nnoremap          <buffer> <LocalLeader>i :<C-u>GoImport
  call add(s:undo, 'nunmap <buffer> <LocalLeader>i')

  nnoremap <silent> <buffer> <LocalLeader>I :<C-u>GoImports<CR>
  call add(s:undo, 'nunmap <buffer> <LocalLeader>I')

  nnoremap <silent> <buffer> gt :call go#alternate#Switch(0, 'vsplit')<CR>
  call add(s:undo, 'nunmap <buffer> <LocalLeader>gt')

  nnoremap <silent> <buffer> gT :call go#alternate#Switch(0, 'split')<CR>
  call add(s:undo, 'nunmap <buffer> <LocalLeader>gT')
endif

if !empty(s:undo)
  let b:undo_ftplugin .= join(s:undo, '|')
endif
