scriptencoding utf-8
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
        \   'type': 'notfound',
        \ }
endif

let g:eskk#debug = 0
let g:eskk#show_annotation = 1

if !exists('$NVIM_GUI') && !has('gui_running')
  let g:eskk#marker_henkan = '<>'
  let g:eskk#marker_henkan_select = '>>'
endif

autocmd MyAutocmd User eskk-initialize-pre call s:eskk_initial_pre()
function! s:eskk_initial_pre() abort "{{{
  let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
  call t.add_map('z ', '　')
  call t.add_map('z(', '（')
  call t.add_map('z)', '）')
  call t.add_map('~', '〜')
  call eskk#register_mode_table('hira', t)
  unlet t
endfunction "}}}
