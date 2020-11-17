"-----------------------------------------------------------------------------
" fzf.vim:
"

"-----------------------------------------------------------------------------
" mappings:
"
" Customize fzf colors to match your color scheme
" let g:fzf_colors = {
"      \   'fg': [ 'fg', 'Normal' ],
"      \   'bg': [ 'bg', 'Normal' ],
"      \   'hl': [ 'fg', 'Comment' ],
"      \   'fg+': [ 'fg', 'CursorLine', 'CursorColumn', 'Normal' ],
"      \   'bg+': [ 'bg', 'CursorLine', 'CursorColumn' ],
"      \   'hl+': [ 'fg', 'Statement' ],
"      \   'info': [ 'fg', 'PreProc' ],
"      \   'border': [ 'fg', 'Ignore' ],
"      \   'prompt': [ 'fg', 'Conditional' ],
"      \   'pointer': [ 'fg', 'Exception' ],
"      \   'marker': [ 'fg', 'Keyword' ],
"      \   'spinner': [ 'fg', 'Label' ],
"      \   'header': [ 'fg', 'Comment' ],
"      \ }

"-----------------------------------------------------------------------------
" mappings:
"
nnoremap <silent> ;b :<C-u>call fzf#vim#buffers()<CR>
nnoremap <silent> ;f :<C-u>call FzfFiles()<CR>
nnoremap <silent> ;l :<C-u>call fzf#vim#buffer_lines()<CR>
nnoremap <silent> ;g :<C-u>call FzfGrep()<CR>
nnoremap <silent> ;e :<C-u>call fzf#run(fzf#wrap(FzfMenu()))<CR>
nnoremap <silent> ;m :<C-u>call fzf#vim#marks()<CR>

"-----------------------------------------------------------------------------
" menu:
"

function! s:simple_items(...) abort "{{{
  return map(copy(a:000), {_, v -> fnamemodify(resolve(expand(v)), ':~')})
endfunction "}}}

function! s:dotfiles_items() abort "{{{
  if empty($DOTFILES) || !isdirectory($DOTFILES)
    return []
  endif

  let l:command = join([
        \   'git',
        \   '-C ',
        \   shellescape($DOTFILES),
        \   'ls-files',
        \   '-co',
        \   '--exclude-standard'
        \ ])

  return map(sort(systemlist(l:command)), {_, v -> '$DOTFILES/' . v})
endfunction "}}}

function! FzfMenu() abort "{{{
  let l:items = []

  let l:items += s:dotfiles_items()
  let l:items += s:simple_items('~/.ssh/config')

  return {
        \   'source': l:items,
        \   'sink': {p ->
        \     execute('edit ' . fnameescape(fnamemodify(expand(p), ':p')))},
        \   'options': ['--prompt', 'Menu> '],
        \ }
endfunction "}}}

"-----------------------------------------------------------------------------
" open files:
"
function! FzfFiles() abort "{{{
  if finddir('.git', ';') !=# ''
    call fzf#vim#gitfiles(getcwd())
  else
    call fzf#vim#files(getcwd())
  endif
endfunction "}}}

"-----------------------------------------------------------------------------
" grep:
"
" priorities: rg > git > default {{{
if executable('rg')
  let s:grep_command = [
        \   'rg',
        \   '--line-number',
        \   '--column',
        \   '--color=always',
        \   '--colors=match:fg:yellow',
        \   '--no-heading',
        \   '--smart-case',
        \ ]
elseif executable('git')
  let s:grep_command = [
        \   'git',
        \   'grep',
        \   '--no-index',
        \   '--color=always',
        \   '--exclude-standard',
        \   '-I',
        \   '--line-number',
        \   '-i',
        \ ]
else
  let s:grep_command = [
        \   'grep',
        \   '-inHr',
        \   '-e',
        \ ]
endif

"}}}

function! FzfGrep() abort "{{{
  let l:pat = input('Pattern: ')
  if empty(l:pat)
    return
  endif

  let l:dir = input('Dir: ', '', 'dir')
  if empty(l:dir)
    let l:dir = '.'
  endif

  let l:cmd = copy(s:grep_command)
  let l:cmd += [ '--', fzf#shellescape(l:pat), fzf#shellescape(l:dir) ]
  echomsg join(l:cmd)
  call fzf#vim#grep(join(l:cmd), v:true, {
        \   'options': [ '--color', 'hl:210,hl+:210,marker:222,info:222' ],
        \ })
endfunction "}}}
