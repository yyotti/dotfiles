"-----------------------------------------------------------------------------
" Initialize:
"

" Delete all my autocmd
augroup MyAutocmd
  autocmd!
  autocmd FileType,ColorScheme,Syntax,BufNewFile,BufNew,BufRead *?
        \ call vimrc#on_filetype()
  " FIXME Check
  " autocmd CursorHold *.toml syntax sync minlines=300
augroup END

let $VIMDIR = fnamemodify($MYVIMRC, ':h')

function! s:source_rc(path) abort "{{{
  execute 'source' fnameescape(vimrc#join_path($VIMDIR, 'rc', a:path))
endfunction "}}}

if has('vim_starting')
  call s:source_rc('init.rc.vim')
endif

"-----------------------------------------------------------------------------
" Plugin Settings:
"
call s:source_rc('packages.rc.vim')

" FIXME Need?
" if has('vim_starting') && argc() > 0
"   call dein#call_hook('source')
"   call dein#call_hook('post_source')
" endif

call vimrc#on_filetype()

"-----------------------------------------------------------------------------
" Encoding:
"
call s:source_rc('encoding.rc.vim')

"-----------------------------------------------------------------------------
" Options:
"
call s:source_rc('options.rc.vim')

"-----------------------------------------------------------------------------
" Filetypes:
"
call s:source_rc('filetypes.rc.vim')

"-----------------------------------------------------------------------------
" Mappings:
"
call s:source_rc('mappings.rc.vim')

"-----------------------------------------------------------------------------
" Platform:
"
if has('nvim')
  call s:source_rc('neovim.rc.vim')
endif

if IsWindows()
  " FIXME Remove?
  " call s:source_rc('windows.rc.vim')
else
  call s:source_rc('unix.rc.vim')
endif

if !has('nvim') && has('gui_running')
  call s:source_rc('gui.rc.vim')
endif

"-----------------------------------------------------------------------------
" Colorscheme:
"
call s:source_rc('colorscheme.rc.vim')

"-----------------------------------------------------------------------------
" Local Settings:
"
if filereadable(expand('~/.vim/vimrc_local'))
  execute 'source' expand('~/.vim/vimrc_local')
endif

set helplang&
set helplang=ja,en
set secure
