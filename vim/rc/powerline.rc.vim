"-----------------------------------------------------------------------------
" Powerline:
"
set noshowmode

set runtimepath+=~/git/powerline/powerline/bindings/vim

autocmd MyAutocmd ColorScheme * call <SID>change_powerline_colorscheme()

function! s:change_powerline_colorscheme() abort "{{{
  let colors_name = g:colors_name
  if colors_name ==# 'solarized'
    let colors_name = 'custom'
  endif

  if colors_name !=# 'custom' && colors_name !=# 'hybrid'
    let colors_name = 'default'
  endif

  let postfix = ''
  if colors_name ==# 'custom' && &background ==# 'light'
    let postfix = 'light'
  endif

  let g:powerline_config_overrides = {
        \   'ext': {
        \     'vim': {
        \       'colorscheme': colors_name . postfix,
        \     },
        \   },
        \ }
  python if 'powerline' in globals(): powerline.reload()
endfunction "}}}
