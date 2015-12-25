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

function! s:change_powerline_colorscheme() abort
  let postfix = ''
  if &background == 'light'
    let postfix = 'light'
  endif

  " powerlineのcolorscheme設定を書き換えてやる
  let g:powerline_config_overrides = {
        \   'ext': {
        \     'vim': {
        \       'colorscheme': 'custom' . postfix,
        \     },
        \   },
        \ }

  python if 'powerline' in globals(): powerline.reload()
endfunction

" vim:set ts=8 sts=2 sw=2 tw=0 expandtab foldmethod=marker:
