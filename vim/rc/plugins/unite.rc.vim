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
  call unite#custom#default_action('directory', 'narrow')

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

nnoremap <silent> <Space>n :UniteNext<CR>
nnoremap <silent> <Space>p :UnitePrevious<CR>

"-----------------------------------------------------------------------------
" menu:
"
let s:candidates = []
function! s:separator(title) abort "{{{
  let ww = &colorcolumn
  let wt = len(a:title)

  let abbr = printf('===== [%s] %s', a:title, repeat('=', ww - wt - 10))
  return {
        \   'word': '',
        \   'abbr': abbr,
        \   'kind': 'common',
        \   'is_dummy': 1,
        \ }
endfunction "}}}

function! s:menu_line(title, path, width) abort "{{{
  let fmt = printf('%%-%ds : %%s', a:width)
  return {
        \   'word': a:path,
        \   'abbr': printf(fmt, a:title, a:path),
        \   'kind': isdirectory(a:path) ? 'directory' : 'file',
        \   'action__path': a:path,
        \ }
endfunction "}}}

function! s:add_candidates(title, candidates) abort "{{{
  let items = map(
        \   filter(
        \     a:candidates,
        \     "v:val !=# '' && (isdirectory(v:val) || filereadable(v:val))"
        \   ),
        \   "[ fnamemodify(v:val, ':t'), fnamemodify(v:val, ':~') ]"
        \ )
  let s:candidates += [ [ a:title, '' ] ] + items
endfunction "}}}

function! s:build_menu() abort "{{{
  let menu = {}

  let menu.title_len_max = max(
        \   map(
        \     filter(copy(s:candidates), "v:val[1] !=# ''"),
        \     'len(v:val[0])'
        \   )
        \ )

  function! menu.map(...) abort "{{{
    " Ignore first argument (key)
    let [ word, path ] = a:2
    let w = self.title_len_max
    return path ==# '' ? s:separator(word) : s:menu_line(word, path, w)
  endfunction "}}}

  let menu.candidates = s:candidates

  let g:unite_source_menu_menus = {}
  let g:unite_source_menu_menus._ = menu
endfunction "}}}

function! s:vimrc_files() abort "{{{
  return filter(glob('~/.vim/rc/**', 0, 1), '!isdirectory(v:val)')
endfunction "}}}

" TODO Add plugin directories
call s:add_candidates('vim', s:vimrc_files())
call s:add_candidates('git', [
      \   resolve(expand('~/.gitconfig')),
      \   resolve(expand('~/.tigrc')),
      \ ])
call s:add_candidates('zsh', [
      \   resolve(expand('~/.zshrc')),
      \   resolve(expand('~/.zshenv')),
      \ ])
call s:add_candidates('others', [
      \   resolve(expand('~/.tmux.conf')),
      \   resolve(expand('~/.ssh/config')),
      \ ])

call s:build_menu()

unlet s:candidates
