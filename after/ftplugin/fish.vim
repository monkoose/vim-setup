vim9script noclear

if exists('b:did_ftplugin')
  finish
endif
b:did_ftplugin = 1

setlocal comments=:#
setlocal commentstring=#%s
setlocal formatoptions+=jn1
setlocal formatoptions-=t
setlocal iskeyword=@,48-57,+,-,_,.
setlocal suffixesadd^=.fish
&l:include='^\s*\.\>'
&l:define = '^\s*function\>'

if executable('fish')
  setlocal formatprg=fish_indent
  b:formatprg = [ 'fish_indent' ]
endif
