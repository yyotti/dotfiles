"-----------------------------------------------------------------------------
" Initialize:
"
if !has('nvim') && v:version < 800
  finish
endif

if !has('nvim') && filereadable(vimrc#join_path($VIMRUNTIME, 'defaults.vim'))
  unlet! g:skip_defaults_vim
  execute 'source' vimrc#join_path($VIMRUNTIME, 'defaults.vim')
endif

function! s:source_rc(path, ...) abort "{{{
  let l:use_global = get(a:000, 0, !has('vim_starting'))
  let l:abspath = resolve(vimrc#join_path($VIMDIR, 'rc', a:path))
  if !l:use_global
    execute 'source' fnameescape(l:abspath)
    return
  endif

  " substitute all 'set' to 'setglobal'
  let l:content = map(readfile(l:abspath),
        \ 'substitute(v:val, "^\\W*\\zsset\\ze\\W", "setglobal", "")')

  " create tempfile and source it
  let l:tmp = tempname()
  try
    call writefile(l:content, l:tmp)
    execute 'source' fnameescape(l:tmp)
  finally
    if filereadable(l:tmp)
      call delete(l:tmp)
    endif
  endtry
endfunction "}}}

" Delete all my autocmd
augroup MyAutocmd
  autocmd!
augroup END

let $VIMDIR = fnamemodify($MYVIMRC, ':h')
if $XDG_CACHE_HOME ==# ''
  let $_CACHE = fnamemodify(vimrc#join_path($HOME, '.cache', 'vim'), ':p')
else
  let $_CACHE = fnamemodify(vimrc#join_path($XDG_CACHE_HOME, 'vim'), ':p')
endif

if has('vim_starting')
  call s:source_rc('init.rc.vim')
endif

"-----------------------------------------------------------------------------
" Plugin Settings:
"
call s:source_rc('dein.rc.vim')

filetype plugin indent on
syntax enable

"-----------------------------------------------------------------------------
" Options:
"
call s:source_rc('encoding.rc.vim')
call s:source_rc('options.rc.vim')
call s:source_rc('mappings.rc.vim')

if has('nvim')
  call s:source_rc('neovim.rc.vim')
endif

call s:source_rc('unix.rc.vim')

"-----------------------------------------------------------------------------
" Colorscheme:
"
call s:source_rc('colorscheme.rc.vim')

"-----------------------------------------------------------------------------
" Local Settings:
"
let s:local_vimrc = fnamemodify(vimrc#join_path($HOME, '.vimrc.local'), ':p')
if filereadable(s:local_vimrc)
  execute 'source' s:local_vimrc
endif

set helplang&
set helplang=ja,en
set secure
