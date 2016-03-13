"-----------------------------------------------------------------------------
" Encoding:
"
if has('vim_starting') && &encoding !=# 'utf-8'
  set encoding=utf-8
endif

if !has('gui_running')
  if $ENV_ACCESS ==# 'linux'
    set termencoding=euc-jp
  elseif $ENV_ACCESS ==# 'colinux'
    set termencoding=utf-8
  else
    " Same as 'encoding'
    set termencoding=
  endif
elseif IsWindows()
  set termencoding=cp932
endif

if has('kaoriya')
  set fileencodings=guess
elseif !exists('g:did_encoding_settings') && has('iconv')
  let &fileencodings = join(
        \   [ 'ucs-bom', 'iso-2022-jp-3', 'utf-8', 'euc-jp', 'cp932' ]
        \ )

  let g:did_encoding_settings = 1
endif

autocmd MyAutocmd BufReadPost * call s:re_check_fenc()
function! s:re_check_fenc() abort "{{{
  let l:is_multi_byte = search("[^\x01-\x7e]", 'n', 100, 100)
  if &fileencoding =~# 'iso-2022-jp' && !l:is_multi_byte
    let &fileencoding = &encoding
  endif
endfunction "}}}

set fileformat=unix
set fileformats=unix,dos,mac

if has('multi_byte_ime')
  set iminsert=0
  set imsearch=0
endif
