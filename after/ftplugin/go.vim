vim9script

setlocal tabstop=4 shiftwidth=4 noexpandtab

def OnWrite()
  g:CocAction('runCommand', 'editor.action.organizeImport')
  g:CocAction('format')
enddef

augroup GoBuffer
  autocmd!
  autocmd BufWritePre <buffer> OnWrite()
augroup END
