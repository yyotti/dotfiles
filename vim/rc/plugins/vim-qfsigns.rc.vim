"-----------------------------------------------------------------------------
" vim-qfsigns.rc.vim:
"
if !exists('g:quickrun_config')
  let g:quickrun_config = {}
endif
if !has_key(g:quickrun_config, 'watchdogs_checker/_')
  let g:quickrun_config['watchdogs_checker/_'] = {}
endif
let g:quickrun_config['watchdogs_checker/_']['hook/qfsigns_update/enable_exit'] = 1
let g:quickrun_config['watchdogs_checker/_']['hook/qfsigns_update/priority_exit'] = 3
