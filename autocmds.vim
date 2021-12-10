augroup CheckTime
  autocmd!
  autocmd FocusGained * silent! checktime
augroup END

augroup MyTerminal
    autocmd!
    autocmd TerminalOpen * set nonumber norelativenumber
augroup END

augroup FileTypeOptions
  autocmd!
  autocmd FileType * syntax sync maxlines=100
  autocmd FileType qf        setlocal wrap
  autocmd FileType vim       setlocal iskeyword-=#
  autocmd FileType svelte,css,scss  setlocal iskeyword+=-
  autocmd FileType gitcommit setlocal spell | startinsert
  autocmd FileType css,html,svelte setlocal shiftwidth=2
  autocmd FileType fugitive nmap <buffer> <C-l> =
augroup END

augroup PostYank
  autocmd!
  autocmd TextYankPost * silent call custom#on_yank#highlight(250)
augroup END
