vim9script

setlocal tabstop=4 shiftwidth=4 noexpandtab

def Format()
  g:CocAction('organizeImport')
  g:CocAction('format')
enddef

augroup GoBuffer
  autocmd!
  autocmd BufWritePre <buffer> Format()
augroup END

nnoremap <buffer> <space>r <Cmd>GoRun<CR>
