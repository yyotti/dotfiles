"-----------------------------------------------------------------------------
" vim-themis.rc.vim:
"
function! s:split_envpath(path) abort "{{{
  let l:delimiter = has('win32') ? ';' : ':'
  if stridx(a:path, '\' . l:delimiter) < 0
    return split(a:path, l:delimiter)
  endif

  let l:split = split(a:path, '\\\@<!\%(\\\\\)*\zs' . l:delimiter)
  return map(
        \   l:split,
        \   'substitute(v:val, ''\\\([\\' . l:delimiter . ']\)'', "\\1", "g")'
        \ )
endfunction "}}}

function! s:join_envpath(list, orig_path, add_path) abort "{{{
  let l:delimiter = has('win32') ? ';' : ':'

  if stridx(a:orig_path, '\' . l:delimiter) < 0 &&
        \ stridx(a:add_path, l:delimiter) < 0
    return join(a:list, l:delimiter)
  else
    return join(map(copy(a:list), 's:escape(v:val)'), l:delimiter)
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

