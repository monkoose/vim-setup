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
augroup END

augroup PostYank
    autocmd!
    autocmd TextYankPost * silent call custom#on_yank#Highlight(250)
augroup END
