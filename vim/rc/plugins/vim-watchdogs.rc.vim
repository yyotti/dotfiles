"-----------------------------------------------------------------------------
" vim-watchdogs.rc.vim:
"
let g:watchdogs_check_BufWritePost_enable = 1
let g:watchdogs_check_BufWritePost_enable_on_wq = 0

if !exists('g:quickrun_config')
  let g:quickrun_config = {}
endif
if !has_key(g:quickrun_config, 'watchdogs_checker/_')
  let g:quickrun_config['watchdogs_checker/_'] = {}
endif
let g:quickrun_config['watchdogs_checker/_']['hook/close_quickfix/enable_exit']
      \ = 1

if executable('tomlv')
  " TOML
  if !has_key(g:quickrun_config, 'toml/watchdogs_checker')
    let g:quickrun_config['toml/watchdogs_checker'] = {}
  endif
  let g:quickrun_config['toml/watchdogs_checker']['type'] =
        \ 'watchdogs_checker/tomlv'
  if !has_key(g:quickrun_config, 'watchdogs_checker/tomlv')
    let g:quickrun_config['watchdogs_checker/tomlv'] = {
          \   'command': 'tomlv',
          \   'exec': '%c %s:p',
          \   'quickfix/errorformat':
          \     '%trror\ in\ ''%f'':\ Near\ line\ %l\ %m',
          \ }
  endif
endif
