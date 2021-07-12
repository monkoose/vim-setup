augroup CheckTime
  autocmd!
  autocmd FocusGained * silent! checktime
augroup END

augroup FileTypeOptions
  autocmd!
  autocmd FileType * syntax sync maxlines=100
  autocmd FileType qf        setlocal wrap
  autocmd FileType vim       setlocal iskeyword-=#
  autocmd FileType css,scss  setlocal iskeyword+=-
  autocmd FileType haskell   setlocal shiftwidth=4
  autocmd FileType gitcommit setlocal spell | startinsert
  autocmd FileType fugitive nmap <buffer> <C-l> =
augroup END

augroup PostYank
  autocmd!
  autocmd TextYankPost * silent call myfunctions#highlight_on_yank(250)
augroup END
