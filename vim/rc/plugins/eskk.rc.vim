"-----------------------------------------------------------------------------
" eskk.vim:
"
let g:eskk#directory = expand('~/.skk')
" Large dic
let g:eskk#large_dictionary = {
      \   'path': '~/.skk/SKK-JISYO.L',
      \   'sorted': 1,
      \   'encoding': 'euc-jp',
      \ }
" User dic
let g:eskk#dictionary = {
      \   'path': '~/.skk/skk-jisyo.user',
      \   'sorted': 0,
      \   'encoding': 'utf-8',
      \ }
" google-ime-skk
if executable('google-ime-skk')
  let g:eskk#server = {
        \   'host': 'localhost',
        \   'port': 55100,
        \   'type': 'dictionary',
        \ }
endif

let g:eskk#debug = 0
let g:eskk#show_annotation = 1

autocmd MyAutocmd User eskk-initialize-pre call s:eskk_initial_pre()
function! s:eskk_initial_pre() abort "{{{
  let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
  call t.add_map('z ', "\u3000")
  call t.add_map('z(', "\uff08")
  call t.add_map('z)', "\uff09")
  call t.add_map('~', "\u301c")
  call eskk#register_mode_table('hira', t)
  unlet t
endfunction "}}}
