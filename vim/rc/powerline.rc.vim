"-----------------------------------------------------------------------------
" Powerline:
"
set noshowmode

set runtimepath+=~/git/powerline/powerline/bindings/vim

nnoremap <silent> <Leader>pr :<C-u>python powerline.reload()<CR>

autocmd MyAutocmd ColorScheme * call <SID>change_powerline_colorscheme()

function! s:change_powerline_colorscheme() abort "{{{
  let l:colors_name = g:colors_name
  if l:colors_name ==# 'solarized'
    let l:colors_name = 'custom'
  endif

  if l:colors_name !=# 'custom' && l:colors_name !=# 'hybrid'
    let l:colors_name = 'default'
  endif

  let l:postfix = ''
  if l:colors_name ==# 'custom' && &background ==# 'light'
    let l:postfix = 'light'
  endif

  let g:powerline_config_overrides = {
        \   'ext': {
        \     'vim': {
        \       'colorscheme': l:colors_name . l:postfix,
        \     },
        \   },
        \ }
  python if 'powerline' in globals(): powerline.reload()
endfunction "}}}
