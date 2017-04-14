let s:save_cpo = &cpoptions
set cpoptions&vim

function! utils#join_path(base, ...) abort "{{{
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

let &cpoptions = s:save_cpo
unlet s:save_cpo
