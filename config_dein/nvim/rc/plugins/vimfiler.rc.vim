scriptencoding utf-8
"-----------------------------------------------------------------------------
" vimfiler.vim:
"
call vimfiler#custom#profile('default', 'context', {
      \   'safe': 0,
      \   'auto_expand': 1,
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

autocmd NvimAutocmd FileType vimfiler call <SID>vimfiler_settings()
function! s:vimfiler_settings() abort
  call vimfiler#set_execute_file('vim', [ 'nvim', 'notepad' ])
  call vimfiler#set_execute_file('txt', 'nvim')

  nnoremap <silent> <buffer> J
        \ :<C-u>Unite -default-action=lcd directory_mru<CR>
endfunction

" vim:set foldmethod=marker:
