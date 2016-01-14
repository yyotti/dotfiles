scriptencoding utf-8
"-----------------------------------------------------------------------------
" vimfiler.vim
"

" 設定 {{{
" セーフモードをデフォルトでOFF
call vimfiler#custom#profile('default', 'context', {
      \   'safe': 0,
      \   'auto_expand': 1,
      \   'parent': 0,
      \ })

" デフォルトのファイラをvimfilerに置き換える
let g:vimfiler_as_default_explorer = 1

if IsWindows()
  " Windowsの場合のドライブ名
  let g:vimfiler_detect_drives = [
        \   'C:/', 'D:/', 'E:/', 'F:/', 'G:/',
        \   'H:/', 'I:/', 'J:/', 'K:/', 'L:/',
        \   'M:/', 'N:/',
        \ ]
endif

if IsWindows()
  " Windowsの場合はゴミ箱を使う
  let g:unite_kind_file_use_trashbox = 1
endif

" ステータスラインを強制的に書き換えるのを抑止する
let g:vimfiler_force_overwrite_statusline = 0

autocmd VimrcAutocmd FileType vimfiler call <SID>vimfiler_settings()
function! s:vimfiler_settings() abort " {{{
  call vimfiler#set_execute_file('vim', [ 'vim', 'notepad' ])
  call vimfiler#set_execute_file('txt', 'vim')

  nnoremap <silent> <buffer> J
        \ :<C-u>Unite -default-action=lcd directory_mru<CR>
endfunction " }}}
" }}}

" vim:set foldmethod=marker:
