augroup CocSetKeymaps
  autocmd!
  autocmd User CocNvimInit nnoremap <silent><expr> <space>d
        \ CocHasProvider('definition') ? CocActionAsync('jumpDefinition') : "\<C-]>"
  autocmd User CocNvimInit nnoremap <silent><expr> K
        \ CocHasProvider('hover') ? CocActionAsync('doHover') : "K"
augroup END

noremap  ;  :
map  Q  gq
sunmap Q
noremap  Y  y$
noremap <expr>  <C-h>  getcharsearch().forward ? ',' : ';'
noremap <expr>  <C-l>  getcharsearch().forward ? ';' : ','

nnoremap  <space>/  <Cmd>nohlsearch<CR>
nnoremap  gx  <Cmd>call myfunctions#OpenPath()<CR>
nnoremap  zS  <Cmd>call myfunctions#Synnames()<CR>
nnoremap  <space>q  <Cmd>pclose<CR>
nnoremap  <space>a  <C-^>
nnoremap  <space>y  "+y
nnoremap  <space>p  "+
nnoremap  <C-j>  <C-d>
nnoremap  <C-k>  <C-u>
nnoremap  <C-n>  <Cmd>call mypopup#ScrolldownOrNextHunk()<CR>
nnoremap  <C-p>  <Cmd>call mypopup#ScrollupOrPrevHunk()<CR>
nnoremap  w  <C-w>w
nnoremap  q  <C-w>c
nnoremap  o  <C-w>o
nnoremap  f  <Cmd>call custom#endofline#Toggle(';')<CR>
nnoremap  2  <Cmd>call myfunctions#ToggleQfWindow()<CR>
nnoremap  3  <Cmd>call myfunctions#ToggleLoclistWindow()<CR>
nnoremap  yow  <Cmd>call custom#unimpaired#ToggleOption('wrap')<CR>
nnoremap  yoc  <Cmd>call custom#unimpaired#ToggleOption('cursorline')<CR>
nnoremap  yox  <Cmd>call custom#unimpaired#ToggleOption('cursorcolumn')<CR>
nnoremap  yos  <Cmd>call custom#unimpaired#ToggleOption('spell')<CR>
nnoremap  yop  <Cmd>call custom#unimpaired#ToggleOption('paste')<CR>
nnoremap  yol  <Cmd>call custom#unimpaired#ToggleOption('list')<CR>
nnoremap  yof  <Cmd>call custom#unimpaired#SwitchOption('foldcolumn', 0, 1)<CR>
nnoremap  yoy  <Cmd>call custom#unimpaired#SwitchOption('colorcolumn', '', 100)<CR>
nnoremap  [<space>  <Cmd>call custom#unimpaired#PasteBlanklineAbove()<CR>
nnoremap  ]<space>  <Cmd>call custom#unimpaired#PasteBlanklineBelow()<CR>
nnoremap  <C-@>  <Cmd>let &iminsert = !&iminsert<CR>
nnoremap  `  <Cmd>call myterm#Toggle()<CR>
nnoremap  <space>mf  <Cmd>call mymake#Buffer()<CR>
nnoremap  <space>mm  <Cmd>call mymake#Makeprg()<CR>

vnoremap  <C-j>  <C-d>
vnoremap  <C-k>  <C-u>
vnoremap  <space>y  "+y

noremap!  <C-@>  <C-^>
inoremap  <C-p>  <C-k>
inoremap  <C-u>  <C-g>u<C-u>
inoremap  h  <Left>
inoremap  l  <Right>
inoremap  f  <Del>

cnoremap  <C-n>  <Down>
cnoremap  <C-p>  <Up>
cnoremap  <C-j>  <C-n>
cnoremap  <C-k>  <C-p>
cnoremap  h  <Left>
cnoremap  l  <Right>
cnoremap <expr>  <C-l>  pumvisible() ? "\<C-y>" : "\<CR>"

set termwinkey=<C-q>
tnoremap  w  <C-q>w
tnoremap  q  <Cmd>close!<CR>
tnoremap  `  <Cmd>call myterm#Toggle()<CR>
tnoremap  <C-q><C-n>  <C-q>N

" Fix slow esc, should be after all Alt remaps
nnoremap <nowait>  <Esc>  <Cmd>call mypopup#ClosePopupAtCursor()<CR>
inoremap <nowait>  <Esc>  <Esc>
xnoremap <nowait>  <Esc>  <Esc>
snoremap <nowait>  <Esc>  <C-c>
cnoremap <nowait>  <Esc>  <C-c>
tnoremap <nowait>  <Esc>  <Esc>

" example ':Time 18 call str2nr(102)'
command! -nargs=1 -complete=command Time call myfunctions#Time(<q-args>)
