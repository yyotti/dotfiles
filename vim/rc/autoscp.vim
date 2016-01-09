scriptencoding utf-8
"--------------------------------------------------------------------------------
" Autoscp:
"

" autoscp
if !neobundle#is_installed('vital.vim') || !executable('scp')
  finish
endif

" .autoscp.json
" {
"     "enable": 1,
"     "host": "",
"     "user": "",
"     "timeout": 10,
"     "remote_base": "/path/to/base",
"     "path_map": {
"         "/path/to/local": "/path/to/remote"
"     }
" }
" ### path_mapに指定するのは相対パスでもよい。 ###
"
" ### パスの作られ方と変換方法 ###
" (前提)
"   ディレクトリ構成が下記のようになっているとする。
"     /local/path/to/project_root
"       ├ users/
"       │    ├ edit/
"       │    │    └ index.html
"       │    └ index.html
"       ├ .autoscp.json
"       └ index.html
"
"     /remote/root
"       ├ members/
"       │    ├ edit/
"       │    │    └ index.html
"       │    └ index.html
"       └ index.html
"
" この場合、.autoscp.json に下記のように記述する。
" {
"     "enable": 1,
"     ... このあたりは省略 ...
"     "remote_base": "/remote/root",
"     "path_map": {
"         "users": "members"
"     }
" }
" remote_baseを空にした場合、sshのホームディレクトリからの相対パスにされる。

augroup VimrcAutocmd
  autocmd BufWinEnter *.php,*.tpl,*.css,*.js call s:vital_init() | call s:autoscp_init()
  autocmd BufWritePost *.php,*.tpl,*.css,*.js call s:autoscp_upload(0)
augroup END

command! AutoScpUpload call s:autoscp_upload(1)
command! AutoScpToggle call s:autoscp_toggle_enable()

let s:autoscp_config_default = {
      \   'enable': 1,
      \   'timeout': -1,
      \   'remote_base': '',
      \   'path_map': {}
      \ }

function! s:vital_init() abort
  if exists('s:Vital')
    return
  endif

  if !neobundle#is_sourced('vital.vim')
    call neobundle#source('vital.vim')
  endif

  let s:Vital = vital#of('vital')
  let s:Json = s:Vital.import('Web.JSON')
endfunction

function! s:add_last_slash(path) abort
  return !empty(a:path) && a:path !~# '/$' ? a:path.'/' : a:path
endfunction

function! s:autoscp_init() abort
  if get(b:, 'autoscp_init', 0)
    return
  endif

  let conf_file_name = get(g:, 'autoscp_conf_name', '.autoscp.json')
  let conf_file = findfile(conf_file_name, fnamemodify(expand('%'), ':p:h') . ';**/')
  if empty(conf_file)
    let b:autoscp_init = 1
    return
  endif

  let conf_file = fnamemodify(conf_file, ':p')
  if !s:load_config(conf_file)
    let b:autoscp_init = 1
    return
  endif

  let local_base = s:add_last_slash(fnamemodify(conf_file, ':p:h'))

  let relpath = s:autoscp_relpath(expand('%:p'), local_base)
  let b:autoscp_remote_dir = fnamemodify(relpath, ':h')
  for from in keys(b:autoscp_config.path_map)
    let remote = s:add_last_slash(b:autoscp_remote_dir)
    if stridx(remote, from) == 0
      let b:autoscp_remote_dir = s:add_last_slash(substitute(remote, from, b:autoscp_config.path_map[from], ''))
      break
    endif
  endfor
  let b:autoscp_remote_dir = s:add_last_slash(b:autoscp_config.remote_base) . b:autoscp_remote_dir

  let b:autoscp_local_path = local_base . relpath

  let b:autoscp_init = 1
endfunction

function! s:autoscp_relpath(path, base) abort
  let p = expand(a:path)
  let b = s:add_last_slash(expand(a:base))

  return stridx(p, b) == 0 ? p[strlen(b):] : p
endfunction

function! s:autoscp_upload(force) abort
  if !exists('b:autoscp_config') || !a:force && !b:autoscp_config.enable
    return
  endif

  let remote = shellescape(b:autoscp_config.user) . '@' . shellescape(b:autoscp_config.host)

  " ディレクトリが存在しなければ作る
  let cmd  = 'ssh'
  let cmd .= ' '
  let cmd .= remote
  let cmd .= ' '
  let cmd .= '"mkdir -p ' . shellescape(b:autoscp_remote_dir) . '"'

  let res = system(cmd)
  if !empty(res)
    call s:err_msg(res)
  endif

  " ファイルコピー
  let cmd  = 'scp'
  if b:autoscp_config.timeout > 0
    let cmd .= ' -o "ConnectTimeout ' . b:autoscp_config.timeout . '"'
  endif
  let cmd .= ' '
  let cmd .= shellescape(b:autoscp_local_path)
  let cmd .= ' '
  let cmd .= remote . ':' . shellescape(b:autoscp_remote_dir)

  let res = system(cmd)
  if !empty(res)
    call s:err_msg(res)
  endif
endfunction

function! s:autoscp_toggle_enable() abort
  if !exists('b:autoscp_config')
    call s:err_msg('autoscpが初期化されていません')
    return
  endif

  let b:autoscp_config.enable = !b:autoscp_config.enable
endfunction

function! s:load_config(file_path) abort
  if !filereadable(a:file_path)
    return 0
  endif

  try
    let json_string = join(readfile(a:file_path), ' ')
    let json = s:Json.decode(json_string)
  catch
    return 0
  endtry

  if !s:check_config(json)
    return 0
  endif

  let b:autoscp_config = json
  call extend(b:autoscp_config, s:autoscp_config_default, 'keep')

  return 1
endfunction

function! s:check_config(config) abort
  if !has_key(a:config, 'host') || type(a:config.host) != 1 || empty(a:config.host)
    call s:err_msg('.autoscp.josn error: hostは文字列で必ず指定してください')
    return 0
  endif

  if !has_key(a:config, 'user') || type(a:config.user) != 1 || empty(a:config.user)
    call s:err_msg('.autoscp.josn error: userは文字列で必ず指定してください')
    return 0
  endif

  if has_key(a:config, 'timeout') && (type(a:config.timeout) != 0 || a:config.timeout < 1)
    call s:err_msg('autoscp error: timeoutは正数で指定してください')
    return 0
  endif

  if has_key(a:config, 'path_map') && (type(a:config.timeout) != 4)
    if type(a:config.path_map) != 4
      call s:err_msg('autoscp error: path_mapは辞書型で指定してください')
      return 0
    endif

    for key in keys(a:config.path_map)
      if type(a:config.path_map[key]) != 1
        call s:err_msg('autoscp error: path_mapの値は文字列でなければなりません')
        return 0
      endif
    endfor
  endif

  if has_key(a:config, 'enable') && type(a:config.enable) != 0
    call s:err_msg('autoscp error: enableは真偽値で指定してください')
    return 0
  endif

  return 1
endfunction

function! s:err_msg(msg) abort
  echohl WarningMsg
  echo a:msg
  echohl None
endfunction

" vim:set sw=2 foldmethod=marker:
