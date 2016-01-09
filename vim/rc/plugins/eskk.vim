scriptencoding utf-8
"--------------------------------------------------------------------------------
" eskk.vim
"

" 設定 {{{
" SKKディレクトリ
let g:eskk#directory = expand('~/.skk')
" Large辞書
let g:eskk#large_dictionary = {
      \   'path': '~/.skk/SKK-JISYO.L',
      \   'sorted': 1,
      \   'encoding': 'euc-jp',
      \ }
" User辞書
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
        \ }
endif

let g:eskk#show_annotation = 1

if !has('gui_running')
  " ターミナルでの表示が崩れるのでマーカーを変える。
  " ターミナルの表示が直ったら消してもいい設定。
  let g:eskk#marker_henkan = '<>'
  let g:eskk#marker_henkan_select = '>>'
else
  " GVimのとき
  set imdisable
endif

" 変換テーブル
autocmd VimrcAutocmd User eskk-initialize-pre call s:eskk_initial_pre()
function! s:eskk_initial_pre() abort
  let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
  call t.add_map('z ', '　')
  call t.add_map('z(', '（')
  call t.add_map('z)', '）')
  call t.add_map('~', '～')
  call eskk#register_mode_table('hira', t)
  unlet t
endfunction

" }}}

" マッピング {{{
imap <C-j> <Plug>(eskk:toggle)
cmap <C-j> <Plug>(eskk:toggle)

" }}}

" vim:set sw=2 foldmethod=marker:
