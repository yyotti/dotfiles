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
call denite#custom#map('insert',
      \ '<C-r>', '<denite:toggle_matchers:matcher/substring>', 'noremap')

" Normal mode mappings
call denite#custom#map('normal',
      \ 'a', '<denite:enter_mode:insert>', 'noremap')
call denite#custom#map('normal',
      \ '<C-g>', '<denite:quit>', 'noremap')
call denite#custom#map('normal',
      \ '<C-v>', '<denite:do_action:vsplit>', 'noremap')
call denite#custom#map('normal',
      \ '<C-s>', '<denite:do_action:split>', 'noremap')

"-----------------------------------------------------------------------------
" sources:
"
call denite#custom#source('file/old', 'matchers',
      \ [ 'matcher/fuzzy', 'matcher/project_files' ])

if has('nvim')
  " call denite#custom#source('file/rec,grep', 'matchers', [ 'matcher/cpsm' ])
endif

call denite#custom#source('file/old', 'converters',
      \ [ 'converter/relative_word' ])


call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
      \ [ 'git', 'ls-files', '-co', '--exclude-standard' ])

"-----------------------------------------------------------------------------
" options:
"
call denite#custom#option('default,grep', {
      \   'prompt': '>',
      \   'highlight_matched_char': 'WarningMsg',
      \   'highlight_mode_normal': 'CursorLine',
      \ })

"-----------------------------------------------------------------------------
" grep:
"
" priorities: rg > ag > pt > git > grep {{{
if executable('rg')
  call denite#custom#var('grep', 'command', [ 'rg' ])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'separator', [ '--' ])
  call denite#custom#var(
        \   'grep',
        \   'default_opts',
        \   [
        \     '--line-number',
        \     '--color=never',
        \     '--no-heading',
        \     '--smart-case',
        \   ]
        \ )

  call denite#custom#var(
        \   'file/rec',
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
        \   'file/rec',
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
        \     '--hidden',
        \   ]
        \ )

  call denite#custom#var(
        \   'file/rec',
        \   'command',
        \   [
        \     'pt',
        \     '--follow',
        \     '--nocolor',
        \     '--nogroup',
        \     '--hidden',
        \     '--ignore=.git',
        \     '-g=',
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

"}}}

"-----------------------------------------------------------------------------
" menu:
"
let s:items = []

function! s:separator(title) abort "{{{
  let l:ww = &colorcolumn ==# 0 ? 78 : &colorcolumn
  let l:wt = len(a:title)

  let l:abbr = printf('===== [%s] %s', a:title, repeat('=', l:ww - l:wt - 10))
  return [ l:abbr, '' ]
endfunction "}}}

function! s:menu_line(item, width) abort "{{{
  let l:fmt = printf('%%-%ds : %%s', a:width)
  return [
        \   printf(l:fmt, a:item.title, fnamemodify(a:item.path, ':~')),
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
  let l:items = map(
        \   filter(a:items, 's:is_valid_item(v:val)'),
        \   "extend(copy(v:val), { 'is_separator': 0 }, 'force')"
        \ )
  let s:items += [ { 'title': a:title, 'is_separator': 1 } ] + l:items
endfunction "}}}

function! s:build_menu() abort "{{{
  let l:title_len_max = max(
        \   map(
        \     filter(copy(s:items), '!v:val.is_separator'),
        \     'len(v:val.title)'
        \   )
        \ )

  let l:menus = {
        \   'file_candidates': map(
        \     s:items,
        \     'v:val.is_separator ?
        \       s:separator(v:val.title) : s:menu_line(v:val, l:title_len_max)'
        \   ),
        \ }

  call denite#custom#var('menu', 'menus', { '_': l:menus })
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
  let l:path = resolve(expand($VIMDIR))
  if !isdirectory(l:path)
    return []
  endif

  let l:command =
        \ 'git -C ' . shellescape(l:path) . ' ls-files -co --exclude-standard'

  return map(
        \   sort(systemlist(l:command)),
        \   '{' .
        \     "'title': v:val," .
        \     "'path': vimrc#join_path(path, v:val)," .
        \   '}'
        \ )
endfunction "}}}

function! s:zsh_items() abort "{{{
  let l:path = resolve(expand('$XDG_CONFIG_HOME/zsh'))
  if !isdirectory(l:path)
    return []
  endif

  let l:command =
        \ 'git -C ' . shellescape(l:path) . ' ls-files -co --exclude-standard'

  let l:zshenv = resolve(expand('~/.zshenv'))
  return [{ 'title': '.zshenv', 'path': l:zshenv }] + map(
        \   sort(systemlist(l:command)),
        \   '{' .
        \     "'title': v:val," .
        \     "'path': vimrc#join_path(path, v:val)," .
        \   '}'
        \ )
endfunction "}}}

function! s:config_items(path) abort "{{{
  let l:path = resolve(expand('~/.config/' . a:path))
  if !isdirectory(l:path)
    return []
  endif

  let l:command =
        \ 'git -C ' . shellescape(l:path) . ' ls-files -co --exclude-standard'

  return map(
        \   sort(systemlist(l:command)),
        \   '{' .
        \     "'title': v:val," .
        \     "'path': vimrc#join_path(path, v:val)," .
        \   '}'
        \ )
endfunction "}}}

function! s:script_items() abort "{{{
  let l:path = resolve(expand('$DOTFILES/scripts'))
  if !isdirectory(l:path)
    return []
  endif

  let l:command =
        \ 'git -C ' . shellescape(l:path) . ' ls-files -co --exclude-standard'

  return map(
        \   sort(systemlist(l:command)),
        \   '{' .
        \     "'title': v:val," .
        \     "'path': vimrc#join_path(path, v:val)," .
        \   '}'
        \ )
endfunction "}}}

call s:add_items('vim', s:vimrc_items())
call s:add_items('zsh', s:zsh_items())
call s:add_items('git', s:config_items('git'))
call s:add_items('tmux', s:config_items('tmux'))
call s:add_items('tig', s:config_items('tig'))
call s:add_items('scripts', s:script_items())
call s:add_items('others', s:simple_items('~/.ssh/config'))

call s:build_menu()

unlet s:items
