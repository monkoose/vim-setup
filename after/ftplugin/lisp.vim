setlocal shiftwidth=2

inoremap <buffer> <Tab> <Plug>(parinfer-tab)
nnoremap <buffer> ( <Cmd>call searchpair("(", "", ")", "bW")<CR>
nnoremap <buffer> ) <Cmd>call searchpair("(", "", ")", "W")<CR>

if !exists('#VlimeLisp')
    augroup VlimeLisp
        autocmd!
        autocmd BufWinEnter *vlime*preview* setlocal previewwindow
    augroup END
endif
