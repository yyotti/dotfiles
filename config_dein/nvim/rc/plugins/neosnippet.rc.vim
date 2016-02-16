scriptencoding utf-8
"-----------------------------------------------------------------------------
" neosnippet.vim:
"
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#enable_complete_done = 1
let g:neosnippet#snippets_directory = NvimDir() . '/snippets'

imap <silent> <C-k> <Plug>(neosnippet_jump_or_expand)
smap <silent> <C-k> <Plug>(neosnippet_jump_or_expand)
xmap <silent> <C-k> <Plug>(neosnippet_expand_target)
imap <silent> <C-l> <Plug>(neosnippet_expand_or_jump)
smap <silent> <C-l> <Plug>(neosnippet_expand_or_jump)
xmap <silent> o <Plug>(neosnippet_register_oneshot_snippet)

" vim:set foldmethod=marker:
