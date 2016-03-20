"-----------------------------------------------------------------------------
" vim-lintexec.nvim:
"
if dein#tap('lightline.vim')
  let g:lintexec#checker_cmd = {
        \   '_': {
        \     'on_exit': function('lightline#update'),
        \   },
        \ }
endif

" Use vim-vimlint
if dein#tap('vim-vimlparser') && dein#tap('vim-vimlint')
  let s:vimlparser = fnamemodify(dein#get('vim-vimlparser').rtp, ':p')
  let s:vimlint = fnamemodify(dein#get('vim-vimlint').rtp, ':p')
  if !exists('g:lintexec#checker_cmd')
    let g:lintexec#checker_cmd = {}
  endif
  if !has_key(g:lintexec#checker_cmd, 'vim')
    let g:lintexec#checker_cmd.vim = {}
  endif
  let g:lintexec#checker_cmd.vim.exec = expand('~/.vim/script/vim-vimlint.sh')
  let g:lintexec#checker_cmd.vim.args = [ s:vimlparser, s:vimlint, tempname() ]
  let g:lintexec#checker_cmd.vim.errfmt =
        \ '%f:%l:%c:%trror: %m,%f:%l:%c:%tarning: %m,%f:%l:%c:%m'

  unlet s:vimlparser
  unlet s:vimlint
endif
