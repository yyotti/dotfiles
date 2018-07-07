"-----------------------------------------------------------------------------
" Initialize:
"
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
  autocmd FileType,Syntax,BufNewFile,BufNew,BufRead *? call vimrc#on_filetype()
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

if has('vim_starting') && argc() > 0
  call vimrc#on_filetype()
endif

if !has('vim_starting')
  call dein#call_hook('source')
  call dein#call_hook('post_source')

  syntax enable
  filetype plugin indent on
endif

"-----------------------------------------------------------------------------
" Options:
"
call s:source_rc('encoding.rc.vim')
call s:source_rc('options.rc.vim')
call s:source_rc('mappings.rc.vim')
if has('nvim')
  call s:source_rc('neovim.rc.vim')
endif
if IsWindows()
  " call s:source_rc('windows.rc.vim')
else
  call s:source_rc('unix.rc.vim')
endif
if !has('nvim') && has('gui_running')
  " call s:source_rc('gui.rc.vim')
endif

"-----------------------------------------------------------------------------
" Colorscheme:
"
call s:source_rc('colorscheme.rc.vim')

"-----------------------------------------------------------------------------
" Local Settings:
"
" 1. user vimrc.local
" 2. project vimrc.local
let s:local_vimrc = [
      \   fnamemodify(vimrc#join_path($HOME, '.vimrc.local'), ':p'),
      \   fnamemodify('./.vimrc.local', ':p'),
      \ ]
call uniq(s:local_vimrc)
for s:file in s:local_vimrc
  if filereadable(s:file)
    execute 'source' s:file
  endif
endfor

set helplang&
set helplang=ja,en
set secure
