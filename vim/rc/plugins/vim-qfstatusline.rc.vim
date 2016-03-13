"-----------------------------------------------------------------------------
" vim-qfstatusline.rc.vim:
"
if !exists('g:quickrun_config')
  let g:quickrun_config = {}
endif
if !has_key(g:quickrun_config, 'watchdogs_checker/_')
  let g:quickrun_config['watchdogs_checker/_'] = {}
endif
let g:quickrun_config['watchdogs_checker/_']['hook/back_window/enable_exit'] = 0
let g:quickrun_config['watchdogs_checker/_']['hook/back_window/priority_exit'] = 1
let g:quickrun_config['watchdogs_checker/_']['hook/qfstatusline_update/enable_exit'] = 1
let g:quickrun_config['watchdogs_checker/_']['hook/qfstatusline_update/priority_exit'] = 2

let g:Qfstatusline#Text = 0
