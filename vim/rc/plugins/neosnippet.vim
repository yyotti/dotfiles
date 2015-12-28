scriptencoding utf-8
"--------------------------------------------------------------------------------
" neosnippet.vim
"

" 設定 {{{
" snipMate互換
" g:snippets_dirを設定するとそこから読んでくれる
let g:neosnippet#enable_snipmate_compatibility = 1
" }}}

" マッピング {{{
" Note: neosnippet_expand_or_jumpにすると、展開が優先される
imap <silent> <C-k> <Plug>(neosnippet_jump_or_expand)
smap <silent> <C-k> <Plug>(neosnippet_jump_or_expand)
xmap <silent> <C-k> <Plug>(neosnippet_expand_target)
imap <silent> <C-l> <Plug>(neosnippet_expand_or_jump)
smap <silent> <C-l> <Plug>(neosnippet_expand_or_jump)
xmap <silent> o <Plug>(neosnippet_register_oneshot_snippet)
" }}}

" vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:
