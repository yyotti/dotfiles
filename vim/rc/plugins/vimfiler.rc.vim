"-----------------------------------------------------------------------------
" vimfiler.vim:
"
call vimfiler#custom#profile('default', 'context', {
      \   'safe': 0,
      \   'parent': 0,
      \ })

let g:vimfiler_as_default_explorer = 1

if IsWindows()
  let g:vimfiler_detect_drives = [
        \   'C:/', 'D:/', 'E:/', 'F:/', 'G:/',
        \   'H:/', 'I:/', 'J:/', 'K:/', 'L:/',
        \   'M:/', 'N:/',
        \ ]

  let g:unite_kind_file_use_trashbox = 1
endif

let g:vimfiler_force_overwrite_statusline = 0

autocmd MyAutocmd FileType vimfiler call <SID>vimfiler_settings()
function! s:vimfiler_settings() abort
  call vimfiler#set_execute_file('vim', [ 'nvim', 'vim', 'notepad' ])
  call vimfiler#set_execute_file('txt', [ 'nvim', 'vim', 'notepad' ])
endfunction
