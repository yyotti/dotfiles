"-----------------------------------------------------------------------------
" denite.nvim:
"

"-----------------------------------------------------------------------------
" mappings:
"

autocmd MyAutocmd FileType denite call s:denite_settings()
function! s:denite_settings() abort "{{{
  nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> q denite#do_map('quit')
  nnoremap <silent><buffer><expr> <C-g> denite#do_map('quit')
  nnoremap <silent><buffer><expr> i denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr><nowait> <Space>
        \ denite#do_map('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> <Tab> denite#do_map('choose_action')
  nnoremap <silent><buffer><expr> <C-x> denite#do_map('do_action', 'split')
  nnoremap <silent><buffer><expr> <C-v> denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> * denite#do_map('toggle_select_all')
  nnoremap <silent><buffer><expr> <C-r> denite#do_map('redraw')
endfunction "}}}

autocmd MyAutocmd FileType denite-filter call s:denite_filter_settings()
function! s:denite_filter_settings() abort "{{{
  imap <silent><buffer><nowait> <C-g> <Plug>(denite_filter_quit)
endfunction "}}}

"-----------------------------------------------------------------------------
" sources:
"
call denite#custom#source('file_mru', 'matchers',
      \ [ 'matcher/fuzzy', 'matcher/project_files' ])

call denite#custom#source('file_mru', 'converters',
      \ [ 'converter/relative_word' ])


call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
      \ [ 'git', 'ls-files', '-co', '--exclude-standard' ])

"-----------------------------------------------------------------------------
" options:
"
call denite#custom#option('_', {
      \   'prompt': '>',
      \   'highlight_matched_char': 'WarningMsg',
      \ })

"-----------------------------------------------------------------------------
" grep/filerec:
"
" priorities: rg > git > default {{{
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
  let $_VIMDIR = '/home/tsutsui/.config/nvim'
  if !isdirectory($_VIMDIR)
    return []
  endif

  let l:command = join([
        \   'git',
        \   '-C ',
        \   shellescape($_VIMDIR),
        \   'ls-files',
        \   '-co',
        \   '--exclude-standard'
        \ ])

  return map(
        \   sort(systemlist(l:command)),
        \   {
        \     _, v -> {
        \       'title': v,
        \       'path': fnamemodify(expand('$_VIMDIR/' . v), ':p'),
        \     }
        \   }
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
        \     "'path': fnamemodify(expand(path . '/' . v:val), ':p')," .
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
        \     "'path': fnamemodify(expand(path . '/' . v:val), ':p')," .
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
        \     "'path': fnamemodify(expand(path . '/' . v:val), ':p')," .
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
