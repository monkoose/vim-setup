if exists('b:did_ftplugin')
  finish
end
let b:did_ftplugin = 1

let s:save_cpo = &cpo
set cpo&vim

setlocal comments=:#
setlocal commentstring=#%s
setlocal define=\\v^\\s*function>
setlocal formatoptions+=jn1
setlocal formatoptions-=t
setlocal include=\\v^\\s*\\.>
setlocal iskeyword=@,48-57,+,-,_,.
setlocal suffixesadd^=.fish

if executable('fish')
  setlocal formatprg=fish_indent
  let b:formatprg = [ 'fish_indent' ]
endif

let &cpo = s:save_cpo
unlet s:save_cpo
