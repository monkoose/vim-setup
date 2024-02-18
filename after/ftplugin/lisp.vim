vim9script noclear

setlocal shiftwidth=2

if !exists('#VlimeLisp')
  augroup VlimeLisp
    autocmd!
    autocmd BufWinEnter *vlime*preview* setlocal previewwindow
  augroup END

  call custom#undo_ftplugin#Set('silent! call autocmd_delete([{"group": "VlimeLisp"}])')
endif

call custom#undo_ftplugin#Set('setl sw<')
