"-----------------------------------------------------------------------------
" unite.vim:
"
let g:unite_enable_auto_select = 0

call unite#custom#profile('default', 'context', {
      \   'start_insert': 1,
      \ })

call unite#custom#source(
      \   'buffer,file_rec,file_rec/async,file_rec/git',
      \   'matchers',
      \   [ 'converter_relative_word', 'matcher_fuzzy' ]
      \ )
call unite#custom#source(
      \   'file_mru',
      \   'matchers',
      \   [
      \     'matcher_fuzzy',
      \     'matcher_hide_hidden_files',
      \     'matcher_hide_current_file',
      \   ]
      \ )
call unite#custom#source(
      \   'buffer,file_rec,file_rec/async,file_rec/git,file_mru',
      \   'converters',
      \   [ 'converter_file_directory' ]
      \ )
call unite#filters#sorter_default#use([ 'sorter_rank' ])

autocmd MyAutocmd FileType unite call <SID>unite_settings()
function! s:unite_settings() abort "{{{
  call unite#custom#alias('file', 'h', 'left')

  if exists('*vimfiler#start') ||
        \ exists('*dein#get') && !empty(dein#get('vimfiler.vim'))
    call unite#custom#default_action('directory', 'open')
  else
    call unite#custom#default_action('directory', 'narrow')
  endif

  nmap <buffer> <C-t> <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-t> <Plug>(unite_toggle_transpose_window)

  let u = unite#get_current_unite()
  if u.profile_name =~# '^search' || u.profile_name =~# '^grep'
    nnoremap <silent> <buffer> <expr> r unite#do_action('replace')
  else
    nnoremap <silent> <buffer> <expr> r unite#do_action('rename')
  endif

  nmap <buffer> x     <Plug>(unite_quick_match_jump)
endfunction "}}}

" Grep command.
" priorities: hw > pt > ag > git > grep  (`pt` can manipulate Japanese)
" However, `hw` is unstable.
" if executable('hw')
"   " https://github.com/tkengo/highway
"   let g:unite_source_grep_command = 'hw'
"   let g:unite_source_grep_default_opts = '--no-group --no-color -n -a -i'
"   let g:unite_source_grep_recursive_opt = ''
if executable('pt')
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor -i'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '-i --nocolor --nogroup --hidden'
        \ . " --ignore '.hg'"
        \ . " --ignore '.svn'"
        \ . " --ignore '.git'"
        \ . "--ignore '.bzr'"
  let g:unite_source_grep_recursive_opt = ''
elseif executable('git')
  let g:unite_source_grep_command = 'git'
  let g:unite_source_grep_default_opts =
        \ 'grep --no-index --no-color --exclude-standard -I --line-number -i'
  let g:unite_source_grep_recursive_opt = ''
endif

nnoremap <silent> <Leader>n :UniteNext<CR>
nnoremap <silent> <Leader>p :UnitePrevious<CR>

"-----------------------------------------------------------------------------
" menu:
"
let s:items = []

function! s:separator(title) abort "{{{
  let ww = &colorcolumn ==# 0 ? 78 : &colorcolumn
  let wt = len(a:title)

  let abbr = printf('===== [%s] %s', a:title, repeat('=', ww - wt - 10))
  return {
        \   'word': '',
        \   'abbr': abbr,
        \   'kind': 'common',
        \   'is_dummy': 1,
        \ }
endfunction "}}}

function! s:menu_line(item, width) abort "{{{
  let fmt = printf('%%-%ds : %%s', a:width)

  let candidate = {
        \   'word': a:item.path,
        \   'abbr': printf(fmt, a:item.title, fnamemodify(a:item.path, ':~')),
        \   'kind': isdirectory(a:item.path) ? 'directory' : 'file',
        \   'action__path': a:item.path,
        \ }
  if has_key(a:item, 'repo') && a:item.repo !=# ''
    let candidate.action__url = 'https://github.com/' . a:item.repo
  endif
  return candidate
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
  let menu = {}

  let menu.title_len_max = max(
        \   map(
        \     filter(copy(s:items), '!v:val.is_separator'),
        \     'len(v:val.title)'
        \   )
        \ )

  function! menu.map(...) abort "{{{
    " Ignore first argument (key)
    let item = a:2
    let w = self.title_len_max
    return item.is_separator ? s:separator(item.title) : s:menu_line(item, w)
  endfunction "}}}

  let menu.candidates = s:items

  let g:unite_source_menu_menus = {}
  let g:unite_source_menu_menus._ = menu
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

function! s:dein_items() abort "{{{
  return map(
        \   values(dein#get()),
        \   '{' .
        \     "'title': get(v:val, 'local', 0) ? " .
        \       "'yyotti/' . fnamemodify(v:val.path, ':t') : v:val.repo," .
        \     "'path': fnamemodify(v:val.path, ':p')," .
        \     "'repo': v:val.repo," .
        \   '}'
        \ )
endfunction "}}}

call s:add_items('vim', s:vimrc_items())
call s:add_items('dein', s:dein_items())
call s:add_items('git', s:simple_items('~/.gitconfig', '~/.tigrc') )
call s:add_items('zsh', s:simple_items('~/.zshrc', '~/.zshenv'))
call s:add_items('others', s:simple_items('~/.tmux.conf', '~/.ssh/config'))

call s:build_menu()

unlet s:items

function! s:input(...) abort "{{{
  new
  cnoremap <buffer> <Esc> __CANCELED__<CR>
  try
    let l:input = call('input', a:000)
    let l:input = l:input =~# '__CANCELED__$' ? 0 : l:input
  catch /^Vim:Interrupt$/
    let l:input = -1
  finally
    bwipeout!
    return l:input
  endtry
endfunction "}}}

function! s:delete(path) abort "{{{
  " Refer to dein#install#_rm()
  if !isdirectory(a:path) && !filereadable(a:path)
    return
  endif

  if has('patch-7.4.1120')
    call delete(a:path, 'rf')
  else
    let path = a:path
    if IsWindows()
      let path = substitute(path, '/', '\\\\', 'g')
    endif

    let rm_command = IsWindows() ? 'rmdir /S /Q' : 'rm -rf'
    let result = system(printf('%s %s', rm_command, shellescape(path)))
    if v:shell_error
      echohl WarningMsg
      echomsg result
      echohl None
    endif
  endif
endfunction "}}}

let s:menu_delete = {
      \   'description': 'Delete selected files/directories',
      \   'is_selectable': 1,
      \ }
function! s:menu_delete.func(candidates) abort "{{{
  for path in map(a:candidates, 'v:val.action__path')
    let input = s:input(printf('Delete %s ? [y/N]:', path))
    if type(input) ==# type(0) && input <= 0 || input !~? '^y\%[es]$'
      continue
    endif

    let full_path = fnamemodify(path, ':p')
    let ftype = getftype(full_path)
    if ftype ==# 'link'
      let msg = printf(
            \   '%s is symbolic link. Delete link target ? [y/N]:', path
            \ )
      let input = s:input(msg)
      if input =~? '^y\%[es]$'
        call s:delete(resolve(full_path))
      endif
    endif
    call s:delete(full_path)
  endfor
endfunction "}}}
call unite#custom#action('source/menu/*', 'delete', s:menu_delete)

let s:menu_open_browser = {
      \   'description': 'Open github repository in browser',
      \   'is_selectable': 1,
      \ }
function! s:menu_open_browser.func(candidates) abort "{{{
  for url in map(a:candidates, "get(v:val, 'action__url', '')")
    if url ==# ''
      continue
    endif

    if exists('*openbrowser#open') ||
          \ exists('*dein#get') && !empty(dein#get('open-browser.vim'))
      call openbrowser#open(url)
    else
      let url = shellescape(url)
      let exec_command = IsWindows() ? 'start' : 'xdg-open'
      if exists('*vimproc#system')
        call vimproc#system(printf('%s %s', exec_command, url))
      else
        call system(printf('%s %s', exec_command, url))
      endif
    endif
  endfor
endfunction "}}}
call unite#custom#action('source/menu/*', 'open_browser', s:menu_open_browser)
