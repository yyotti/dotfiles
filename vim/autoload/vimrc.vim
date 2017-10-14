function! vimrc#on_filetype() abort "{{{
  if execute('filetype') =~# 'OFF'
    silent! filetype plugin indent on
    syntax enable
    filetype detect
  endif
endfunction "}}}

function! vimrc#join_path(base, ...) abort "{{{
  let l:paths = filter(
        \   map(
        \     map(
        \       copy(a:000),
        \       { _, part -> type(part) !=# v:t_string ? string(part) : part }
        \     ),
        \     { _, val ->
        \       join(filter(split(val, '/'), { _, val -> !empty(val) }), '/') }
        \   ),
        \   { _, val -> !empty(val) }
        \ )
  return empty(l:paths) ? a:base : join([ a:base ] + l:paths, '/')
endfunction "}}}

function! vimrc#input(...) abort "{{{
  new
  cnoremap <buffer> <Esc> __CANCELED__<CR>
  try
    let l:input = call('input', a:000)
    let l:input = l:input =~# '__CANCELED__$' ? 0 : l:input
  catch /^Vim:Interrupt$/
    let l:input = -1
  finally
    bwipeout!
    return l:input
  endtry
endfunction "}}}

function! vimrc#error(msg) abort "{{{
  let l:msg = index([ v:t_string, v:t_number ], type(a:msg)) < 0
        \ ? string(a:msg) : a:msg
  echohl ErrorMsg
  echomsg l:msg
  echohl None
endfunction "}}}
