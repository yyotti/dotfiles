scriptencoding utf-8
"--------------------------------------------------------------------------------
" Powerline:
"
if !PowerlineEnabled()
  finish
endif

set noshowmode

set rtp+=~/git/powerline/powerline/bindings/vim

" powerline再起動のコマンド
nnoremap <silent> <Leader>pr :<C-u>python powerline.reload()<CR>

" リアルタイムにカラースキームを書き換えるための細工
" TODO できれば、この制御はPowerline側でやりたい
augroup VimrcAutocmd
  autocmd ColorScheme * call <SID>change_powerline_colorscheme()
augroup END

function! s:change_powerline_colorscheme() abort " {{{
  let s:colors_name = g:colors_name
  if s:colors_name ==# 'solarized'
    " powerline側のsolarizedをcustomの名前で改造しているので変更する
    let s:colors_name = 'custom'
  endif

  if s:colors_name !=# 'custom' && s:colors_name !=# 'hybrid'
    let s:colors_name = 'default'
  endif

  let postfix = ''
  if s:colors_name ==# 'custom' && &background == 'light'
    let postfix = 'light'
  endif

  " powerlineのcolorscheme設定を書き換えてやる
  let g:powerline_config_overrides = {
        \   'ext': {
        \     'vim': {
        \       'colorscheme': s:colors_name . postfix,
        \     },
        \   },
        \ }

  unlet s:colors_name

  python if 'powerline' in globals(): powerline.reload()
endfunction " }}}

" vim:set sw=2 foldmethod=marker:
