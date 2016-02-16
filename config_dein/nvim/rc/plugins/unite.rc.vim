scriptencoding utf-8
"-----------------------------------------------------------------------------
" unite.vim:
"
let g:neomru#file_mru_limit = 200

call unite#custom#profile('default', 'context', {
      \   'start_insert': 1,
      \ })

" grepに使うコマンドを指定。
" 優先順位は hw > pt > ag > git > grep  (ptは日本語を扱えるということで)
" ただ、hwは不安定らしく同じ条件で検索しても結果が異なる。安定したら再度
" 試して決める。
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

" vim:set foldmethod=marker:
