let s:save_cpo = &cpoptions
set cpoptions&vim

function! vimrc#utils#join_path(base, ...) abort "{{{
  let paths = filter(
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
  return empty(paths) ? a:base : join([ a:base ] + paths, '/')
endfunction "}}}

function! vimrc#utils#input(...) abort "{{{
  new
  cnoremap <buffer> <Esc> __CANCELED__<CR>
  try
    let input = call('input', a:000)
    let input = input =~# '__CANCELED__$' ? 0 : input
  catch /^Vim:Interrupt$/
    let input = -1
  finally
    bwipeout!
    return input
  endtry
endfunction "}}}

function! vimrc#utils#error(msg) abort "{{{
  let msg = index([ v:t_string, v:t_number ], type(a:msg)) < 0
        \ ? string(a:msg) : a:msg
  echohl ErrorMsg
  echomsg msg
  echohl None
endfunction "}}}

let &cpoptions = s:save_cpo
unlet s:save_cpo
