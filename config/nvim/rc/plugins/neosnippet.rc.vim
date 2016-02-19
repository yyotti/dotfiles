scriptencoding utf-8
"-----------------------------------------------------------------------------
" neosnippet.vim:
"
imap <silent> <C-k> <Plug>(neosnippet_jump_or_expand)
smap <silent> <C-k> <Plug>(neosnippet_jump_or_expand)
xmap <silent> <C-k> <Plug>(neosnippet_expand_target)
imap <silent> <C-l> <Plug>(neosnippet_expand_or_jump)
smap <silent> <C-l> <Plug>(neosnippet_expand_or_jump)
xmap <silent> o <Plug>(neosnippet_register_oneshot_snippet)

let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#enable_complete_done = 1
if !exists('g:neosnippet#snippets_directory')
  let g:neosnippet#snippets_directory = ''
endif

let s:snippets_dir =
      \ (NvimDir() . '/snippets')
let s:dirs = split(g:neosnippet#snippets_directory, ',')
for s:dir in s:dirs
  if s:dir ==# s:snippets_dir
    finish
  endif
endfor

let g:neosnippet#snippets_directory =
      \ join(add(s:dirs, s:snippets_dir), ',')

" vim:set foldmethod=marker:
