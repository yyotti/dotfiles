function! ale_linters#vim#vimlparser#handle(buffer, lines) abort "{{{
  let l:pattern = '\vvimlparser: (.+): line (\d+) col (\d+)$'
  let l:output = []

  for l:line in a:lines
    let l:mt = matchlist(l:line, l:pattern)
    if len(l:mt) == 0
      continue
    endif

    let l:text = l:mt[1]

    call add(l:output, {
          \   'lnum': l:mt[2] + 0,
          \   'col': l:mt[3] + 0,
          \   'text': l:text,
          \   'type': l:text =~# '^E' ? 'E' : 'W',
          \ })
  endfor

  return l:output
endfunction "}}}

call ale#linter#Define('vim', {
      \   'name': 'vimlparser',
      \   'executable': 'vimlparser',
      \   'command':  'vimlparser' . (has('nvim') ? ' -neovim' : ''),
      \   'callback': 'ale_linters#vim#vimlparser#handle',
      \   'output_stream': 'stderr',
      \})

if !IsWindows()
  " TODO
  " let g:neomake_vim_enabled_makers = [ 'vimlint' ]
  " let g:neomake_vim_vimlint_maker = {
  "       \   'exe': expand('~/.vim/script/vimlint.sh'),
  "       \   'args': [ '-u' ],
  "       \   'errorformat':
  "       \     '%f:%l:%c:%trror: %m,%f:%l:%c:%tarning: %m,%f:%l:%c:%m',
  "       \ }
endif

