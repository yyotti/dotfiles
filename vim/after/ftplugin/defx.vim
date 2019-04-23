if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif
let s:undo = []

" Define mappings
nnoremap <silent><buffer><expr><nowait> <CR> defx#async_action('open')
call add(s:undo, 'nunmap <buffer> <CR>')

nnoremap <silent><buffer><expr><nowait> c defx#do_action('copy')
call add(s:undo, 'nunmap <buffer> c')

nnoremap <silent><buffer><expr><nowait> ! defx#do_action('execute_command')
call add(s:undo, 'nunmap <buffer> !')

nnoremap <silent><buffer><expr><nowait> m defx#do_action('move')
call add(s:undo, 'nunmap <buffer> m')

nnoremap <silent><buffer><expr><nowait> p defx#do_action('paste')
call add(s:undo, 'nunmap <buffer> p')

nnoremap <silent><buffer><expr><nowait> l defx#async_action('open')
call add(s:undo, 'nunmap <buffer> p')

nnoremap <silent><buffer><expr><nowait> <C-v> defx#do_action('open', 'vsplit')
call add(s:undo, 'nunmap <buffer> <C-v>')

nnoremap <silent><buffer><expr><nowait> K defx#do_action('new_directory')
call add(s:undo, 'nunmap <buffer> K')

nnoremap <silent><buffer><expr><nowait> N defx#do_action('new_file')
call add(s:undo, 'nunmap <buffer> N')

nnoremap <silent><buffer><expr><nowait> C
      \ defx#do_action('toggle_columns', 'mark:filename:type:size:time')
call add(s:undo, 'nunmap <buffer> C')

nnoremap <silent><buffer><expr><nowait> d defx#do_action('remove')
call add(s:undo, 'nunmap <buffer> d')

nnoremap <silent><buffer><expr><nowait> r defx#do_action('rename')
call add(s:undo, 'nunmap <buffer> r')

nnoremap <silent><buffer><expr><nowait> .
      \ defx#do_action('toggle_ignored_files')
call add(s:undo, 'nunmap <buffer> .')

nnoremap <silent><buffer><expr><nowait> yy defx#do_action('yank_path')
call add(s:undo, 'nunmap <buffer> yy')

nnoremap <silent><buffer><expr><nowait> h defx#do_action('cd', ['..'])
call add(s:undo, 'nunmap <buffer> h')

nnoremap <silent><buffer><expr><nowait> q defx#do_action('quit')
call add(s:undo, 'nunmap <buffer> q')

nnoremap <silent><buffer><expr><nowait> <C-Space>
      \ defx#do_action('toggle_select') . 'j'
call add(s:undo, 'nunmap <buffer> <C-Space>')

nnoremap <silent><buffer><expr><nowait> * defx#do_action('toggle_select_all')
call add(s:undo, 'nunmap <buffer> *')

nnoremap <silent><buffer><expr><nowait> <Tab>
      \ winnr('$') != 1 ?
      \ ':<C-u>wincmd w<CR>' :
      \ ':<C-u>Defx -buffer-name=temp -split=vertical<CR>'
call add(s:undo, 'nunmap <buffer> <Tab>')

if !empty(s:undo)
  let b:undo_ftplugin .= join(s:undo, '|')
endif
