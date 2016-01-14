scriptencoding utf-8
"-----------------------------------------------------------------------------
" vim-gitgutter.vim
"

" 設定 {{{
let g:gitgutter_sign_added = 'A'
let g:gitgutter_sign_modified = 'M'
let g:gitgutter_sign_removed = 'D'
let g:gitgutter_sign_modified_removed = 'MD'

" デフォルトのマッピングをOFFにする
let g:gitgutter_map_keys = 0
" }}}

" マッピング {{{
nnoremap <silent> [git]h :<C-u>GitGutterLineHighlightsToggle<CR>

" デフォルトマッピングを無効にしているので、必要なものを追加する
nmap [c <Plug>GitGutterPrevHunkzvzz
nmap ]c <Plug>GitGutterNextHunkzvzz
" }}}

" vim:set foldmethod=marker:
