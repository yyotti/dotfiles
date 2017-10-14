"-----------------------------------------------------------------------------
" Encoding:
"

autocmd MyAutocmd BufReadPost * call s:re_check_fenc()
function! s:re_check_fenc() abort "{{{
  let l:is_multi_byte = search("[^\x01-\x7e]", 'n', 100, 100)
  if &fileencoding =~# 'iso-2022-jp' && !l:is_multi_byte
    let &fileencoding = &encoding
  endif
endfunction "}}}

" set fileformat=unix
set fileformats=unix,dos,mac
