vim9script noclear

setlocal shiftwidth=2

if !exists('#VlimeLisp')
    augroup VlimeLisp
        autocmd!
        autocmd BufWinEnter *vlime*preview* setlocal previewwindow
    augroup END
endif
