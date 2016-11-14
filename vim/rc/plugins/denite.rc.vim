"-----------------------------------------------------------------------------
" denite.nvim:
"

"-----------------------------------------------------------------------------
" mappings:
"

" All mode mappings
call denite#custom#map('_', '<C-g>', 'quit')
call denite#custom#map('_', '<C-n>', 'move_to_next_line')
call denite#custom#map('_', '<C-p>', 'move_to_prev_line')
call denite#custom#map('_', '<Tab>', 'choose_action')

" Insert mode mappings
call denite#custom#map('insert', '<C-g>', 'quit')
call denite#custom#map('insert', '<Tab>', 'choose_action')
call denite#custom#map('insert', '<C-t>', 'paste_from_register')
call denite#custom#map('insert', '<C-d>', 'scroll_window_downwards')
call denite#custom#map('insert', '<C-u>', 'scroll_window_upwards')
call denite#custom#map('insert', '<C-f>', 'scroll_page_forwards')
call denite#custom#map('insert', '<C-b>', 'scroll_page_backwards')

" Normal mode mappings
call denite#custom#map('normal', 'a', 'enter_mode:insert')

call denite#custom#source(
      \  'file_mru', 'matchers', [ 'matcher_fuzzy', 'matcher_project_files' ]
      \ )
call denite#custom#source('file_rec,grep', 'matchers', [ 'matcher_cpsm' ])
call denite#custom#source(
      \   'grep', 'matchers', [ 'matcher_ignore_globs', 'matcher_cpsm' ]
      \ )
call denite#custom#source(
      \   'file_mru', 'converters', [ 'converter_relative_word' ]
      \ )

call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#var('file_rec/git', 'command',
      \ [ 'git', 'ls-files', '-co', '--exclude-standard' ])

call denite#custom#option('default', 'prompt', '>')

"-----------------------------------------------------------------------------
" grep:
"
" priorities: rg > ag > pt > git > grep {{{
if executable('rg')
  call denite#custom#var('grep', 'command', [ 'rg' ])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'separator', [ '--' ])
  " TODO Segmentation fault occured when '--smart-case'
  call denite#custom#var(
        \   'grep',
        \   'default_opts',
        \   [
        \     '--line-number',
        \     '--color=never',
        \     '--no-heading',
        \   ]
        \ )
elseif executable('ag')
  call denite#custom#var('grep', 'command', [ 'ag' ])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'separator', [])
  call denite#custom#var(
        \   'grep',
        \   'default_opts',
        \   [
        \     '--ignore', '.hg',
        \     '--ignore', '.svn',
        \     '--ignore', '.git',
        \     '--ignore', '..bzr',
        \   ]
        \ )
elseif executable('pt')
  call denite#custom#var('grep', 'command', [ 'pt' ])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'separator', [])
  call denite#custom#var(
        \   'grep',
        \   'default_opts',
        \   [
        \     '--nogroup',
        \     '--nocolor',
        \     '--smart-case',
        \   ]
        \ )
elseif executable('git')
  call denite#custom#var('grep', 'command', [ 'git' ])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'separator', [ '--' ])
  call denite#custom#var(
        \   'grep',
        \   'default_opts',
        \   [
        \     'grep',
        \     '--no-index',
        \     '--no-color',
        \     '--exclude-standard',
        \     '-I',
        \     '--line-number',
        \     '-i',
        \   ]
        \ )
endif

" nnoremap <silent> <Leader>n :UniteNext<CR>
" nnoremap <silent> <Leader>p :UnitePrevious<CR>
"}}}

"-----------------------------------------------------------------------------
" menu:
"
" TODO
