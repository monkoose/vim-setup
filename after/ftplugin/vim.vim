vim9script

setlocal iskeyword-=# shiftwidth=2
&l:define = '^\s*\%(export\s\)\=\s*\%(def\|const\|var\|final\)'

nnoremap <buffer> <space>ft <Cmd>setfiletype vim<CR>

call custom#undo_ftplugin#Set('setl iskeyword< sw< define<')
call custom#undo_ftplugin#Set('exe "nunmap <buffer> <space>ft"')
