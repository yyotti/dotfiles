"-----------------------------------------------------------------------------
" Encoding:
"

autocmd MyAutocmd BufReadPost * call s:re_check_fenc()
function! s:re_check_fenc() abort "{{{
  let is_multi_byte = search("[^\x01-\x7e]", 'n', 100, 100)
  if &fileencoding =~# 'iso-2022-jp' && !is_multi_byte
    let &fileencoding = &encoding
  endif
endfunction "}}}

" set fileformat=unix
set fileformats=unix,dos,mac

" TODO in init.rc.vim?
" if has('vim_starting') && &encoding !=# 'utf-8'
"   if IsWindows() && !has('gui_running')
"     set encoding=cp932
"   else
"     set encoding=utf-8
"   endif
" endif

" TODO in init.rc.vim?
" if !has('gui_running') && IsWindows()
"   set termencoding=cp932
" endif

" TODO in init.rc.vim?
" if !exists('did_encoding_settings')
"   let &fileencodings = join(
"         \   [ 'ucs-bom', 'iso-2022-jp-3', 'utf-8', 'euc-jp', 'cp932' ], ','
"         \ )
"
"   let g:did_encoding_settings = 1
" endif

" TODO in init.rc.vim?
" if has('multi_byte_ime')
"   set iminsert=0
"   set imsearch=0
" endif
