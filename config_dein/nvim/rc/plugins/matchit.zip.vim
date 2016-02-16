scriptencoding utf-8
"-----------------------------------------------------------------------------
" matchit.zip.vim
"

function! s:set_match_words() abort " {{{
  let l:words = [ '(:)', '{:}', '[:]', '（:）', '「:」' ]
  if exists('b:match_words')
    for l:w in l:words
      if b:match_words !~# '\V' . l:w
        let b:match_words .= ',' . l:w
      endif
    endfor
  else
    let b:match_words = join(l:words, ',')
  endif
endfunction " }}}

augroup matchit-setting
  autocmd!
  autocmd BufEnter * call s:set_match_words()
augroup END

silent! execute 'doautocmd FileType' &filetype

" vim:set foldmethod=marker:
