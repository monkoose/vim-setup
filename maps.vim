noremap            Q           gq
noremap            Y           y$
nnoremap <silent>  <F3>        <Cmd>setlocal spell!<CR>
nnoremap <silent>  <space>/    <Cmd>nohlsearch<CR>
nnoremap           w         <C-w>w
nnoremap <silent>  f         <Cmd>call custom#endofline#Toggle(';')<CR>
nnoremap <silent>  <C-n>       <Cmd>call mypopup#Scrolldown_or_next_hunk()<CR>
nnoremap <silent>  <C-p>       <Cmd>call mypopup#Scrollup_or_prev_hunk()<CR>
nnoremap <silent>  2         <Cmd>call myfunctions#Toggle_qf_window()<CR>
nnoremap <silent>  3         <Cmd>call myfunctions#Toggle_loclist_window()<CR>
nnoremap <silent>  gx          <Cmd>call myfunctions#Open_path()<CR>
nnoremap <silent>  zS          <Cmd>call myfunctions#Synnames()<CR>
nnoremap           <space>q    <Cmd>pclose<CR>
nnoremap <silent>  <space>a    <C-^>
nnoremap           <space>d    <C-]>
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
nnoremap           yof         <Cmd>call custom#unimpaired#SwitchOption('foldcolumn', '0', '1')<CR>
nnoremap           yoy         <Cmd>call custom#unimpaired#SwitchOption('colorcolumn', '', '100')<CR>
nnoremap           [<space>    <Cmd>call custom#unimpaired#PasteBlanklineAbove()<CR>
nnoremap           ]<space>    <Cmd>call custom#unimpaired#PasteBlanklineBelow()<CR>
nnoremap <silent>  <C-@>       <Cmd>let &iminsert = !&iminsert<CR>
nnoremap           ;           :
nnoremap           <C-h>       ,
nnoremap           <C-l>       ;
nnoremap           `         <Cmd>call myterm#Toggle()<CR>
nnoremap           <space>mf   <Cmd>call mymake#Buffer()<CR>
nnoremap           <space>mm   <Cmd>call mymake#Makeprg()<CR>

vnoremap           <space>y    "+y
vnoremap           <C-j>       <C-d>
vnoremap           <C-k>       <C-u>
vnoremap           ;           :
vnoremap           <C-h>       ,
vnoremap           <C-l>       ;

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

set termwinkey=<C-q>
tnoremap           w       <C-q>w
tnoremap <silent>  q       <Cmd>close!<CR>
tnoremap           <C-q><C-n> <C-q>N
tnoremap           `       <Cmd>call myterm#toggle()<CR>

" Fix slow esc, should be after all Alt remaps
nnoremap <silent><nowait>  <Esc>     <Cmd>call mypopup#Close_popup_atcursor()<CR>
inoremap <nowait>          <Esc>     <Esc>
xnoremap <nowait>          <Esc>     <Esc>
snoremap <nowait>          <Esc>     <C-c>
cnoremap <nowait>          <Esc>     <C-c>
tnoremap <nowait>          <Esc>     <Esc>

" example ':Time 18 call str2nr(102)'
command! -nargs=1 -complete=command Time call myfunctions#Time(<q-args>)
