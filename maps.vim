augroup CocSetKeymaps
  autocmd!
  autocmd User CocNvimInit nnoremap <silent><expr> <space>d
        \ CocHasProvider('definition') ? CocActionAsync('jumpDefinition') : "\<C-]>"
  autocmd User CocNvimInit nnoremap <silent><expr> K
        \ CocHasProvider('hover') ? CocActionAsync('doHover') : "K"
augroup END

noremap            Q           gq
noremap            Y           y$
nnoremap <silent>  <space>/    <Cmd>nohlsearch<CR>
nnoremap           w         <C-w>w
nnoremap <silent>  f         <Cmd>call custom#endofline#Toggle(';')<CR>
nnoremap <silent>  <C-n>       <Cmd>call mypopup#ScrolldownOrNextHunk()<CR>
nnoremap <silent>  <C-p>       <Cmd>call mypopup#ScrollupOrPrevHunk()<CR>
nnoremap <silent>  2         <Cmd>call myfunctions#ToggleQfWindow()<CR>
nnoremap <silent>  3         <Cmd>call myfunctions#ToggleLoclistWindow()<CR>
nnoremap <silent>  gx          <Cmd>call myfunctions#OpenPath()<CR>
nnoremap <silent>  zS          <Cmd>call myfunctions#Synnames()<CR>
nnoremap           <space>q    <Cmd>pclose<CR>
nnoremap <silent>  <space>a    <C-^>
" nnoremap           <space>d    <C-]>
nnoremap           <space>y    "+y
nnoremap           <space>p    "+
nnoremap           <C-j>       <C-d>
nnoremap           <C-k>       <C-u>
nnoremap           q         <C-w>c
nnoremap           o         <C-w>o
nnoremap           yow         <Cmd>call custom#unimpaired#ToggleOption('wrap')<CR>
nnoremap           yoc         <Cmd>call custom#unimpaired#ToggleOption('cursorline')<CR>
nnoremap           yox         <Cmd>call custom#unimpaired#ToggleOption('cursorcolumn')<CR>
nnoremap           yos         <Cmd>call custom#unimpaired#ToggleOption('spell')<CR>
nnoremap           yol         <Cmd>call custom#unimpaired#ToggleOption('list')<CR>
nnoremap           yof         <Cmd>call custom#unimpaired#SwitchOption('foldcolumn', 0, 1)<CR>
nnoremap           yoy         <Cmd>call custom#unimpaired#SwitchOption('colorcolumn', '', 100)<CR>
nnoremap           [<space>    <Cmd>call custom#unimpaired#PasteBlanklineAbove()<CR>
nnoremap           ]<space>    <Cmd>call custom#unimpaired#PasteBlanklineBelow()<CR>
nnoremap <silent>  <C-@>       <Cmd>let &iminsert = !&iminsert<CR>
nnoremap           ;           :
nnoremap <expr>    <C-h>       getcharsearch().forward ? ',' : ';'
nnoremap <expr>    <C-l>       getcharsearch().forward ? ';' : ','
nnoremap           `         <Cmd>call myterm#Toggle()<CR>
nnoremap           <space>mf   <Cmd>call mymake#Buffer()<CR>
nnoremap           <space>mm   <Cmd>call mymake#Makeprg()<CR>

vnoremap           <space>y    "+y
vnoremap           <C-j>       <C-d>
vnoremap           <C-k>       <C-u>
vnoremap           ;           :
vnoremap <expr>    <C-h>       getcharsearch().forward ? ',' : ';'
vnoremap <expr>    <C-l>       getcharsearch().forward ? ';' : ','

noremap!           <C-@>         <C-^>
inoremap           <C-p>       <C-k>
inoremap           h         <Left>
inoremap           l         <Right>
inoremap           f         <Del>
inoremap           <C-u>       <C-g>u<C-u>

cnoremap           <C-n>       <Down>
cnoremap           <C-p>       <Up>
cnoremap           <C-j>       <C-n>
cnoremap           <C-k>       <C-p>
cnoremap           h         <Left>
cnoremap           l         <Right>
cnoremap <expr> <C-l> pumvisible() ? "\<C-y>" : "\<CR>"

set termwinkey=<C-q>
tnoremap           w       <C-q>w
tnoremap <silent>  q       <Cmd>close!<CR>
tnoremap           <C-q><C-n> <C-q>N
tnoremap           `       <Cmd>call myterm#Toggle()<CR>

" Fix slow esc, should be after all Alt remaps
nnoremap <silent><nowait>  <Esc>     <Cmd>call mypopup#ClosePopupAtCursor()<CR>
inoremap <nowait>          <Esc>     <Esc>
xnoremap <nowait>          <Esc>     <Esc>
snoremap <nowait>          <Esc>     <C-c>
cnoremap <nowait>          <Esc>     <C-c>
tnoremap <nowait>          <Esc>     <Esc>

" example ':Time 18 call str2nr(102)'
command! -nargs=1 -complete=command Time call myfunctions#Time(<q-args>)
