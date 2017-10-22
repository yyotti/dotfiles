if exists('b:after_current_syntax')
  finish
endif

" highlight variable 'err'
highlight default link goErr WarningMsg
syntax match goErr /\<err\>/
