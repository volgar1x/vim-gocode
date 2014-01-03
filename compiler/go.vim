" Vim compiler file
" Compiler:	Go
" Last Change:	2014 Jan 3

if exists('current_compiler')
  finish
endif
let current_compiler = 'checkstyle'

if exists(':CompilerSet') != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

if exists('b:gopackage')
    execute 'CompilerSet makeprg=go\ build\ $*\ ' . escape(b:gopackage, ' \')
else
    CompilerSet makeprg=go\ build\ $*\ %
endif

CompilerSet errorformat=%f:%l:\ %m
