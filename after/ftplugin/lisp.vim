vim9script

setlocal shiftwidth=2

b:matchparen_config = {
  syntax_groups: ['string', 'comment', 'escape', 'symbol'],
}

if !exists('#VlimeLisp')
    augroup VlimeLisp
        autocmd!
        autocmd BufWinEnter *vlime*preview* setlocal previewwindow
    augroup END
endif
