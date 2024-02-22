vim9script

setlocal tabstop=4 shiftwidth=4 noexpandtab
setlocal listchars-=tab:→-
setlocal listchars+=tab:\ \ ,lead:·

def Format()
  g:CocAction('organizeImport')
  g:CocAction('format')
enddef

augroup GoBuffer
  autocmd! BufWritePre <buffer>
  autocmd BufWritePre <buffer> Format()
augroup END

call custom#undo_ftplugin#Set('setl ts< sw< et< listchars<')
call custom#undo_ftplugin#Set('exe "nunmap <buffer> <space>r"')
