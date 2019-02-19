" options {{{
call gina#custom#command#option('status', '-b|--branch')
call gina#custom#command#option('status', '-s|--short')
call gina#custom#command#option('status', '--ignore-submodule')
call gina#custom#command#option('/\%(status\|commit\)', '-u|--untracked-files')
call gina#custom#command#option('commit', '--restore')
call gina#custom#command#option('log', '--all')
call gina#custom#command#option('log', '--graph')
call gina#custom#command#option('log', '--pretty',
      \ 'format:"%C(yellow)%h%Creset -%C(bold blue)%d%Creset %s %Cgreen(%cr)"')
call gina#custom#command#option('log', '--abbrev-commit')
call gina#custom#command#option('log', '--date', 'relative')
call gina#custom#command#option('log', '--opener', 'tabnew')

" set status window height
call gina#custom#execute('status', 'setlocal winfixheight')
" }}}

" log {{{
call gina#custom#mapping#nmap('log', 'yy', '<Plug>(gina-yank-rev)')
call gina#custom#mapping#nmap('log', 'yp', '<Plug>(gina-yank-path)')
" }}}

" branch {{{
call gina#custom#mapping#nmap('branch', 'mM',
      \ '<Plug>(gina-branch-commit-merge)')
call gina#custom#mapping#nmap('branch', 'dd',
      \ '<Plug>(gina-branch-delete)')
call gina#custom#mapping#nmap('branch', 'dD',
      \ '<Plug>(gina-branch-delete-force)')
call gina#custom#mapping#nmap('branch', 'rr',
      \ '<Plug>(gina-commit-rebase)')
" TODO define mapping for `git rebase -i`
" call gina#custom#mapping#nmap('branch', 'ri',
"       \ '<Plug>(gina-commit-rebase-i)')
" }}}

" status {{{
call gina#custom#mapping#nmap('status', '<CR>', '<Plug>(gina-edit)')
call gina#custom#mapping#nmap('status', 'ev',
      \ ':call gina#action#call(''edit:right'')<CR>',
      \ { 'noremap': 1, 'silent': 1 })
call gina#custom#mapping#nmap('status', 'es',
      \ ':call gina#action#call(''edit:below'')<CR>',
      \ { 'noremap': 1, 'silent': 1 })
call gina#custom#mapping#nmap('status', 'et', '<Plug>(gina-edit-tab)')
call gina#custom#mapping#nmap('status', 'dd', '<Plug>(gina-compare-tab)')
call gina#custom#mapping#nmap('status', '-', '<Plug>(gina-index-toggle)')
" call gina#custom#mapping#nmap('status', '!', '<Plug>(gina-commit-amend)')
call gina#custom#mapping#nmap('status', 'cc', ':Gina commit<CR>',
      \ { 'noremap': 1, 'silent': 1 })
call gina#custom#mapping#nmap('status', 'cn', ':Gina now --stat<CR>',
      \ { 'noremap': 1, 'silent': 1 })
call gina#custom#mapping#nmap('status', 'ca', ':Gina commit --amend<CR>',
      \ { 'noremap': 1, 'silent': 1 })

" TODO Change behavior by state (new file/staged/unstaged)
call gina#custom#mapping#nmap('status', 'U', '<Plug>(gina-index-checkout)')
" }}}

" Disable builtin mappings
call gina#custom#mapping#map('/.*', 'm+', '<Nop>')
call gina#custom#mapping#map('/.*', 'm-', '<Nop>')
call gina#custom#mapping#map('/.*', 'm*', '<Nop>')

" Remapping <C-h/j/k/l>
call gina#custom#mapping#nmap('/.*', '<C-h>', '<C-w>h')
call gina#custom#mapping#nmap('/.*', '<C-j>', '<C-w>j')
call gina#custom#mapping#nmap('/.*', '<C-k>', '<C-w>k')
call gina#custom#mapping#nmap('/.*', '<C-l>', '<C-w>l')
