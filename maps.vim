noremap            Q           gq
noremap            Y           y$
nnoremap <silent>  <F3>        <Cmd>setlocal spell!<CR>
nnoremap <silent>  <space>/    <Cmd>nohlsearch<CR>
nnoremap           w         <C-w>w
nnoremap <silent>  f         <Cmd>call myfunctions#toggle_semicolon()<CR>
nnoremap <silent>  <C-n>       <Cmd>call mypopup#scrolldown_or_next_hunk()<CR>
nnoremap <silent>  <C-p>       <Cmd>call mypopup#scrollup_or_prev_hunk()<CR>
nnoremap <silent>  2         <Cmd>call myfunctions#toggle_qf_window()<CR>
nnoremap <silent>  3         <Cmd>call myfunctions#toggle_loclist_window()<CR>
nnoremap <silent>  gx          <Cmd>call myfunctions#open_path()<CR>
nnoremap <silent>  zS          <Cmd>call myfunctions#synnames()<CR>
nnoremap           <space>q    <Cmd>pclose<CR>
nnoremap <silent>  <space>a    <C-^>
nnoremap           <space>d    <C-]>
nnoremap           <space>y    "+y
nnoremap           <space>p    "+
nnoremap           <C-j>       <C-d>
nnoremap           <C-k>       <C-u>
nnoremap           q         <C-w>c
nnoremap           o         <C-w>o
nnoremap <silent>  yof         <Cmd>let &foldcolumn = !&foldcolumn<CR>
nnoremap <silent>  yoy         <Cmd>let &cc = &cc == '' ? 100 : ''<CR>
nnoremap <silent>  <C-@>       <Cmd>let &iminsert = !&iminsert<CR>
nnoremap           ;           :
nnoremap           <C-h>       ,
nnoremap           <C-l>       ;
nnoremap           `         <Cmd>call myterm#toggle()<CR>
nnoremap           <space>mf   <Cmd>call mymake#buffer()<CR>
nnoremap           <space>mm   <Cmd>call mymake#makeprg()<CR>

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
nnoremap <silent><nowait>  <Esc>     <Cmd>call mypopup#close_popup_atcursor()<CR>
inoremap <nowait>          <Esc>     <Esc>
xnoremap <nowait>          <Esc>     <Esc>
snoremap <nowait>          <Esc>     <C-c>
cnoremap <nowait>          <Esc>     <C-c>
tnoremap <nowait>          <Esc>     <Esc>

" example ':Time 18 call str2nr(102)'
command! -nargs=1 -complete=command Time call myfunctions#time(<q-args>)
