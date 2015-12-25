scriptencoding utf-8
"--------------------------------------------------------------------------------
" matchit.zip.vim
"

" matchit.vimをロードする
runtime macros/matchit.vim

function! s:set_match_words() abort " {{{
  echomsg string('yobareta')
  let words = [ '(:)', '{:}', '[:]', '（:）', '「:」' ]
  if exists('b:match_words')
    for w in words
      if b:match_words !~ '\V' . w
        let b:match_words .= ',' . w
      endif
    endfor
  else
    let b:match_words = join(words, ',')
  endif
endfunction " }}}

augroup matchit-setting
  autocmd!
  autocmd BufEnter * call s:set_match_words()
augroup END

silent! execute 'doautocmd FileType' &filetype

" vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:
