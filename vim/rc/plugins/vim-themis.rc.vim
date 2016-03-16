"-----------------------------------------------------------------------------
" vim-themis.rc.vim:
"
function! s:split_envpath(path) abort "{{{
  let delimiter = has('win32') ? ';' : ':'
  if stridx(a:path, '\' . delimiter) < 0
    return split(a:path, delimiter)
  endif

  let split = split(a:path, '\\\@<!\%(\\\\\)*\zs' . delimiter)
  return map(
        \   split,
        \   'substitute(v:val, ''\\\([\\' . delimiter . ']\)'', "\\1", "g")'
        \ )
endfunction "}}}

function! s:join_envpath(list, orig_path, add_path) abort "{{{
  let delimiter = has('win32') ? ';' : ':'

  if stridx(a:orig_path, '\' . delimiter) < 0 &&
        \ stridx(a:add_path, delimiter) < 0
    return join(a:list, delimiter)
  else
    return join(map(copy(a:list), 's:escape(v:val)'), delimiter)
  endif
endfunction "}}}

function! s:escape(path) abort "{{{
  return substitute(a:path, ',\|\\,\@=', '\\\0', 'g')
endfunction "}}}

let s:bin = dein#get('vim-themis').rtp . '/bin'
let $PATH = s:join_envpath(
      \   dein#util#_uniq(insert(s:split_envpath($PATH), s:bin)),
      \   $PATH,
      \   s:bin
      \ )
let $THEMIS_HOME = dein#get('vim-themis').rtp

unlet s:bin

