"-----------------------------------------------------------------------------
" lightline.vim:
"
" Anywhere SID
function! s:SID_PREFIX() abort " {{{
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction " }}}

set noshowmode

let g:lightline = {
      \   'separator': {
      \     'left': IsWindows() ? '' : "\u2b80",
      \     'right': IsWindows() ? '' : "\u2b82",
      \   },
      \   'subseparator': {
      \     'left': IsWindows() ? '' : "\u2b81",
      \     'right': IsWindows() ? '' : "\u2b83",
      \   },
      \   'active': {
      \     'left': [
      \       [ 'mode', 'eskk' ],
      \       [ 'filename' ],
      \       [ 'branch', 'gitinfo' ],
      \     ],
      \     'right': [
      \       [ 'syntaxcheck', 'lineinfo' ],
      \       [ 'fileformat', 'fileencoding', 'filetype' ],
      \     ],
      \   },
      \   'inactive': {
      \     'left': [
      \       [ 'inactivemode' ],
      \       [ 'filename' ],
      \       [ 'branch', 'gitinfo' ],
      \     ],
      \     'right': [
      \       [ 'syntaxcheck', 'lineinfo' ],
      \       [ 'fileformat', 'fileencoding', 'filetype' ],
      \     ],
      \   },
      \   'component': {
      \     'inactivemode': '%{"INACTIVE"}',
      \     'lineinfo': (IsWindows() ? ' ' : "\u2b61 ") . '%v:%l/%L',
      \     'fileformat': '%{'.s:SID_PREFIX().'fileinfo_visible()?&fileformat:""}',
      \     'filetype': '%{'.s:SID_PREFIX().'fileinfo_visible()?(!empty(&filetype)?&filetype:"no ft"):""}',
      \     'fileencoding': '%{'.s:SID_PREFIX().'fileinfo_visible()?(!empty(&fileencoding)?&fileencoding:&encoding):""}',
      \   },
      \   'component_function': {
      \     'mode': s:SID_PREFIX().'mode',
      \     'eskk': s:SID_PREFIX().'eskk',
      \     'branch': s:SID_PREFIX().'branch',
      \     'gitinfo': s:SID_PREFIX().'gitinfo',
      \     'filename': s:SID_PREFIX().'filename',
      \   },
      \   'component_expand': {
      \     'syntaxcheck': s:SID_PREFIX() . 'error_count',
      \   },
      \   'component_visible_condition': {
      \     'eskk': s:SID_PREFIX().'eskk_visible()',
      \     'branch': s:SID_PREFIX().'branch_visible()',
      \     'fileformat': s:SID_PREFIX().'fileinfo_visible()',
      \     'filetype': s:SID_PREFIX().'fileinfo_visible()',
      \     'fileencoding': s:SID_PREFIX().'fileinfo_visible()',
      \     'gitinfo': s:SID_PREFIX().'gitinfo_visible()',
      \   },
      \   'component_type': {
      \     'syntaxcheck': 'error',
      \   },
      \ }

function! s:mode() abort "{{{
  return &filetype ==# 'unite' ? 'Unite' :
        \ &filetype ==# 'vimfiler' ? 'VimFiler' :
        \ winwidth(0) > 60 ? lightline#mode() :
        \ ''
endfunction "}}}

function! s:readonly() abort "{{{
  return &filetype !~? 'help\|vimfiler' && &readonly ? (IsWindows() ? '[R]' : "\u2b64") : ''
endfunction "}}}

function! s:modified() abort "{{{
  return &filetype =~# 'help\|vimfiler' ? '' :
        \ &modified ? '+' :
        \ &modifiable ? '' :
        \ '-'
endfunction "}}}

function! s:filename() abort "{{{
  return (!empty(s:readonly()) ? s:readonly().' ' : '') .
        \ (&filetype ==? 'vimfiler' ? vimfiler#get_status_string() :
        \   &filetype ==? 'unite' ? substitute(
        \     unite#get_status_string(), ' | ', '', ''
        \   ) :
        \   !empty(expand('%')) ? expand('%') : '[No file]') .
        \   (!empty(s:modified()) ? ' ' . s:modified() : '')
endfunction "}}}

function! s:eskk_visible() abort "{{{
  return exists('*eskk#statusline') && !empty(eskk#statusline())
endfunction "}}}

function! s:eskk() abort "{{{
  return s:eskk_visible() ?
        \ matchlist(eskk#statusline(), '^\[eskk:\(.\+\)\]$')[1] : ''
endfunction "}}}

function! s:branch_visible() abort "{{{
  return &filetype !=# 'vimfiler' &&
        \ dein#tap('vim-fugitive') && !empty(fugitive#head())
endfunction "}}}

function! s:branch() abort "{{{
  return s:branch_visible() ?
        \ (IsWindows() ? '' : "\u2b60 ") . fugitive#head() : ''
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

  let l:symbols = [
        \   g:gitgutter_sign_added,
        \   g:gitgutter_sign_modified,
        \   g:gitgutter_sign_removed,
        \ ]
  let l:hunks = GitGutterGetHunkSummary()

  return join(
        \   filter(
        \     map([0, 1, 2], "l:symbols[v:val] . ':' . l:hunks[v:val]"),
        \     "v:val[-2:] !=# ':0'"
        \   ),
        \   ' '
        \ )
endfunction "}}}

function! s:fileinfo_visible() abort "{{{
  return &filetype !=# 'unite' && &filetype !=# 'vimfiler' && winwidth(0) > 70
endfunction "}}}

function! s:error_count() abort "{{{
  if !dein#tap('ale')
    return ''
  endif

  return '%{join(values(map(copy('.s:SID_PREFIX().'ale_errors()),'
        \ . '"printf(''%s(%d)'', v:key, v:val)")))}'
endfunction "}}}

function! s:ale_errors() abort "{{{
  let l:cnt = ale#statusline#Count(bufnr(''))

  let l:counts = {}

  let l:errors = l:cnt.error + l:cnt.style_error
  if l:errors > 0
    let l:counts['E'] = l:errors
  endif

  let l:warnings = l:cnt.total - l:errors
  if l:warnings > 0
    let l:counts['W'] = l:warnings
  endif

  return l:counts
endfunction "}}}

function! s:lightline_update() abort "{{{
  let g:lightline.colorscheme = 'default'
  if g:colors_name =~# 'solarized'
    let g:lightline.colorscheme = 'solarized'
  endif

  if !has('vim_starting')
    try
      call lightline#init()
      call lightline#colorscheme()
      call lightline#update()
    catch
    endtry
  endif
endfunction "}}}
