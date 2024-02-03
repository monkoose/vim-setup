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

nnoremap <buffer> <space>r <Cmd>Sh go run .<CR>
