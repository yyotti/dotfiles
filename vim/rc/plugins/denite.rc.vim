"-----------------------------------------------------------------------------
" denite.nvim:
"

"-----------------------------------------------------------------------------
" mappings:
"

" Insert mode mappings
call denite#custom#map('insert',
      \ '<C-n>', '<denite:move_to_next_line>')
call denite#custom#map('insert',
      \ '<C-p>', '<denite:move_to_previous_line>')
call denite#custom#map('insert',
      \ '<C-g>', '<denite:quit>', 'noremap')
call denite#custom#map('insert',
      \ '<C-t>', '<denite:paste_from_register>', 'noremap')
call denite#custom#map('insert',
      \ '<C-d>', '<denite:scroll_window_downwards>', 'noremap')
call denite#custom#map('insert',
      \ '<C-u>', '<denite:scroll_window_upwards>', 'noremap')
call denite#custom#map('insert',
      \ '<C-f>', '<denite:scroll_page_forwards>', 'noremap')
call denite#custom#map('insert',
      \ '<C-b>', '<denite:scroll_page_backwards>', 'noremap')
call denite#custom#map('insert',
      \ '<C-a>', '<denite:move_caret_to_head>', 'noremap')
call denite#custom#map('insert',
      \ '<C-k>', '<denite:delete_text_after_caret>', 'noremap')
call denite#custom#map('insert',
      \ '<C-v>', '<denite:do_action:vsplit>', 'noremap')
call denite#custom#map('insert',
      \ '<C-x>', '<denite:do_action:split>', 'noremap')

" Normal mode mappings
call denite#custom#map('normal',
      \ 'a', '<denite:enter_mode:insert>', 'noremap')
call denite#custom#map('normal',
      \ '<C-g>', '<denite:quit>', 'noremap')
call denite#custom#map('normal',
      \ '<C-v>', '<denite:do_action:vsplit>', 'noremap')
call denite#custom#map('normal',
      \ '<C-s>', '<denite:do_action:split>', 'noremap')

call denite#custom#source('file_old', 'matchers', [ 'matcher_fuzzy' ])
if has('nvim')
  call denite#custom#source('file_rec,grep', 'matchers', [ 'matcher_cpsm' ])
endif
call denite#custom#source('file_old', 'converters',
      \ [ 'converter_relative_word' ])

call denite#custom#source(
      \   'grep', 'matchers', [ 'matcher_ignore_globs', 'matcher_cpsm' ]
      \ )

call denite#custom#var('file_rec', 'command',
      \ [ 'rg', '--files', '--glob', '!.git' ])

call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#var('file_rec/git', 'command',
      \ [ 'git', 'ls-files', '-co', '--exclude-standard' ])

call denite#custom#option('default,grep', 'prompt', '>')
call denite#custom#option(
      \   'default,grep', 'highlight_matched_char', 'WarningMsg'
      \ )
call denite#custom#option(
      \   'default,grep', 'highlight_mode_normal', 'CursorLine'
      \ )
call denite#custom#option(
      \   'default,grep', 'highlight_mode_insert', 'CursorLine'
      \ )

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

  call denite#custom#var(
        \   'file_rec',
        \   'command',
        \   [
        \     'rg',
        \     '--files',
        \     '--glob',
        \     '!.git',
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
        \     '--ignore', '.bzr',
        \   ]
        \ )

  call denite#custom#var(
        \   'file_rec',
        \   'command',
        \   [
        \     'ag',
        \     '--follow',
        \     '--nocolor',
        \     '--nogroup',
        \     '-g',
        \     '',
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

  call denite#custom#var(
        \   'file_rec',
        \   'command',
        \   [
        \     'pt',
        \     '--follow',
        \     '--nocolor',
        \     '--nogroup',
        \     '--hidden',
        \     '-g',
        \     '',
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
let s:items = []

function! s:separator(title) abort "{{{
  let ww = &colorcolumn ==# 0 ? 78 : &colorcolumn
  let wt = len(a:title)

  let abbr = printf('===== [%s] %s', a:title, repeat('=', ww - wt - 10))
  return [ abbr, '' ]
endfunction "}}}

function! s:menu_line(item, width) abort "{{{
  let fmt = printf('%%-%ds : %%s', a:width)
  return [
        \   printf(fmt, a:item.title, fnamemodify(a:item.path, ':~')),
        \   a:item.path
        \ ]
endfunction "}}}

function! s:is_valid_item(item) abort "{{{
  return type(a:item) ==# type({}) &&
        \ has_key(a:item, 'title') &&
        \ has_key(a:item, 'path') &&
        \ (isdirectory(a:item.path) || filereadable(a:item.path))
endfunction "}}}

function! s:add_items(title, items) abort "{{{
  let items = map(
        \   filter(a:items, 's:is_valid_item(v:val)'),
        \   "extend(copy(v:val), { 'is_separator': 0 }, 'force')"
        \ )
  let s:items += [ { 'title': a:title, 'is_separator': 1 } ] + items
endfunction "}}}

function! s:build_menu() abort "{{{
  let title_len_max = max(
        \   map(
        \     filter(copy(s:items), '!v:val.is_separator'),
        \     'len(v:val.title)'
        \   )
        \ )

  let menus = {
        \   'file_candidates': map(
        \     s:items,
        \     'v:val.is_separator ?
        \       s:separator(v:val.title) : s:menu_line(v:val, title_len_max)'
        \   ),
        \ }

  call denite#custom#var('menu', 'menus', { '_': menus })
endfunction "}}}

function! s:simple_items(...) abort "{{{
  return map(
        \   copy(a:000),
        \   '{' .
        \     "'title': v:val," .
        \     "'path': fnamemodify(resolve(expand(v:val)), ':p')," .
        \   '}'
        \ )
endfunction "}}}

function! s:vimrc_items() abort "{{{
  let prefix = expand('~/.vim/rc/')

  return map(
      \   filter(glob(prefix . '**', 0, 1), '!isdirectory(v:val)'),
      \   '{' .
      \     "'title': strpart(v:val, strlen(prefix))," .
      \     "'path': fnamemodify(v:val, ':p')," .
      \   '}'
      \ )
endfunction "}}}

function! s:fish_items() abort "{{{
  let prefix = expand('~/.config/fish/')

  return map(
      \   filter(
      \     glob(prefix . '**', 0, 1),
      \     '!isdirectory(v:val)' .
      \     ' && fnamemodify(v:val, ":t") !=# "fzf_key_bindings.fish"' .
      \     ' && fnamemodify(v:val, ":t") !~# "fishd\\.[0-9a-f]\\+"'
      \   ),
      \   '{' .
      \     "'title': strpart(v:val, strlen(prefix))," .
      \     "'path': fnamemodify(v:val, ':p')," .
      \   '}'
      \ )
endfunction "}}}

call s:add_items('vim', s:vimrc_items())
call s:add_items('git', s:simple_items('~/.gitconfig', '~/.tigrc') )
call s:add_items('zsh', s:simple_items('~/.zshrc', '~/.zshenv'))
call s:add_items('fish', s:fish_items())
call s:add_items('others', s:simple_items('~/.tmux.conf', '~/.ssh/config'))

call s:build_menu()

unlet s:items
