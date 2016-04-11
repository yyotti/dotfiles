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
let g:unite_source_menu_menus = {}

" rc files
function! s:vimrc_files() abort "{{{
  let base = fnamemodify(expand('~/.vim/rc'), ':p')
  let base_len = len(base) + 1
  return map(
        \   glob(base . '/**', 0, 1),
        \   '[ v:val[base_len :], v:val ]'
        \ )
endfunction "}}}
let g:unite_source_menu_menus.vimrc = {
      \   'description': 'Edit vimrc files',
      \ }
let g:unite_source_menu_menus.vimrc.file_candidates = <SID>vimrc_files()

let g:unite_source_menu_menus.rc  = {
      \   'description': 'Edit rc files',
      \ }
let g:unite_source_menu_menus.rc.file_candidates = [
      \   [ 'zshrc', resolve(expand('~/.zshrc')) ],
      \   [ 'zshenv', resolve(expand('~/.zshenv')) ],
      \   [ 'tmux.conf', resolve(expand('~/.tmux.conf')) ],
      \   [ 'tigrc', resolve(expand('~/.tigrc')) ],
      \ ]
