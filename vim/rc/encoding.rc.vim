"-----------------------------------------------------------------------------
" Encoding:
"

set fileformat=unix
set fileformats=unix,dos,mac

"
" Commands:
"

" encoding
command! -bang -bar -complete=file -nargs=? EditUTF8
      \ edit<bang> ++encoding=utf-8 <args>
command! -bang -bar -complete=file -nargs=? EditCP932
      \ edit<bang> ++encoding=cp932 <args>
command! -bang -bar -complete=file -nargs=? EditEUCJP
      \ edit<bang> ++encoding=euc-jp <args>

" fileencoding
command! WriteUTF8 setlocal fileencoding=utf-8
command! WriteCP932 setlocal fileencoding=cp932
command! WriteEUCJP setlocal fileencoding=euc-jp

" fileformat
command! -bang -complete=file -nargs=? Lf
      \ write<bang> ++fileformat=unix <args> | edit <args>
command! -bang -complete=file -nargs=? Crlf
      \ write<bang> ++fileformat=dos <args> | edit <args>
