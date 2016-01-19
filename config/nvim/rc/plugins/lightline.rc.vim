scriptencoding utf-8
"-----------------------------------------------------------------------------
" lightline.vim:
"
" Anywhere SID
function! s:SID_PREFIX() abort " {{{
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction " }}}

let g:Qfstatusline#UpdateCmd = function('lightline#update')

set noshowmode

let g:lightline = {
      \   'separator': {
      \     'left': '⮀',
      \     'right': '⮂',
      \   },
      \   'subseparator': {
      \     'left': '⮁',
      \     'right': '⮃',
      \   },
      \   'active': {
      \     'left': [
      \       [ 'mode', 'eskk' ],
      \       [ 'filename' ],
      \       [ 'fugitive', 'gitinfo' ],
      \     ],
      \     'right': [
      \       [ 'syntaxcheck', 'lineinfo' ],
      \       [ 'fileformat', 'fileencoding', 'filetype' ],
      \       [ 'anzu' ],
      \     ],
      \   },
      \   'inactive': {
      \     'left': [
      \       [ 'inactivemode' ],
      \       [ 'filename' ],
      \       [ 'fugitive', 'gitinfo' ],
      \     ],
      \     'right': [
      \       [ 'syntaxcheck', 'lineinfo' ],
      \       [ 'fileformat', 'fileencoding', 'filetype' ],
      \       [ 'anzu' ],
      \     ],
      \   },
      \   'component': {
      \     'inactivemode': '%{"INACTIVE"}',
      \     'lineinfo': '⭡ %3l:%-2v (%p%%)',
      \     'fileformat': '%{'.s:SID_PREFIX().'fileinfo_visible()?&fileformat:""}',
      \     'filetype': '%{'.s:SID_PREFIX().'fileinfo_visible()?(!empty(&filetype)?&filetype:"no ft"):""}',
      \     'fileencoding': '%{'.s:SID_PREFIX().'fileinfo_visible()?(!empty(&fileencoding)?&fileencoding:&encoding):""}',
      \     'anzu': '%{'.s:SID_PREFIX().'anzu_visible()?'.s:SID_PREFIX().'anzu():""}',
      \   },
      \   'component_function': {
      \     'mode': s:SID_PREFIX().'mode',
      \     'eskk': s:SID_PREFIX().'eskk',
      \     'fugitive': s:SID_PREFIX().'fugitive',
      \     'gitinfo': s:SID_PREFIX().'gitinfo',
      \     'filename': s:SID_PREFIX().'filename',
      \   },
      \   'component_expand': {
      \     'syntaxcheck': 'qfstatusline#update',
      \   },
      \   'component_visible_condition': {
      \     'eskk': s:SID_PREFIX().'eskk_visible()',
      \     'fugitive': s:SID_PREFIX().'fugitive_visible()',
      \     'fileformat': s:SID_PREFIX().'fileinfo_visible()',
      \     'filetype': s:SID_PREFIX().'fileinfo_visible()',
      \     'fileencoding': s:SID_PREFIX().'fileinfo_visible()',
      \     'gitinfo': s:SID_PREFIX().'gitinfo_visible()',
      \     'anzu': s:SID_PREFIX().'anzu_visible()',
      \   },
      \   'component_type': {
      \     'syntaxcheck': 'error',
      \   },
      \ }

" TODO 表示条件はwinwidthの判定を最初にもっていく

function! s:mode() abort "{{{
  return &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ winwidth(0) > 60 ? lightline#mode() :
        \ ''
endfunction "}}}

function! s:readonly() abort "{{{
  return &filetype !~? 'help\|vimfiler' && &readonly ? '⭤' : ''
endfunction "}}}

function! s:modified() abort "{{{
  return &filetype =~# 'help\|vimfiler' ? '' :
        \ &modified ? '+' :
        \ &modifiable ? '' :
        \ '-'
endfunction "}}}

function! s:eskk_visible() abort "{{{
  return exists('*eskk#statusline') && !empty(eskk#statusline())
endfunction "}}}

function! s:eskk() abort "{{{
  return s:eskk_visible() ?
        \ matchlist(eskk#statusline(), '^\[eskk:\(.\+\)\]$')[1] : ''
endfunction "}}}

function! s:fugitive_visible() abort "{{{
  return &ft != 'vimfiler' &&
        \ exists('*fugitive#head') && !empty(fugitive#head())
endfunction "}}}

function! s:fugitive() abort "{{{
  return s:fugitive_visible() ? '⭠ ' . fugitive#head() : ''
endfunction "}}}

function! s:gitinfo_visible() abort "{{{
  return exists('*GitGutterGetHunkSummary') &&
        \ get(g:, 'gitgutter_enabled', 0) &&
        \ winwidth(0) > 90
endfunction "}}}

function! s:gitinfo() abort "{{{
  if !s:gitinfo_visible()
    return ''
  endif

  " TODO もうちょっとエレガントに書きたい
  let symbols = [
        \   g:gitgutter_sign_added . ' ',
        \   g:gitgutter_sign_modified . ' ',
        \   g:gitgutter_sign_removed . ' ',
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor

  return join(ret, ' ')
endfunction "}}}

function! s:fileinfo_visible() abort "{{{
  return &ft != 'unite' && &ft != 'vimfiler' && winwidth(0) > 70
endfunction "}}}

function! s:anzu_visible() abort "{{{
  return exists('*anzu#search_status') &&
        \ !empty(anzu#search_status()) &&
        \ winwidth(0) > 70
endfunction "}}}

function! s:anzu() abort "{{{
  return anzu#search_status()
endfunction "}}}

" リアルタイムにカラースキームを書き換えるための細工
autocmd NvimAutocmd ColorScheme * call <SID>lightline_update()
function! s:lightline_update() abort "{{{
  try
    if g:colors_name =~# 'wombat\|solarized\|landsca;e\|jellybeans\|Tomorrow'
      let g:lightline.colorscheme =
            \ substitute(
            \   substitute(g:folors_name, '-', '_', 'g'), '256.*, '', ''
            \ ) . (g:colors_name ==# 'solarized' ? '_' . &background : '')
    else
      let g:lightline.colorscheme = 'default'
    endif
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
  catch
  endtry
endfunction "}}}

" vim:set foldmethod=marker:
