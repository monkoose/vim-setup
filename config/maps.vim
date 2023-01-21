vim9script noclear

import autoload '../autoload/myfunctions.vim' as mf
import autoload '../autoload/custom/unimpaired.vim'
import autoload '../autoload/custom/endofline.vim'
import autoload '../autoload/mypopup.vim'
import autoload '../autoload/myterm.vim'

noremap  ;  :
map  Q  gq
sunmap Q
noremap  Y  y$
noremap <expr>  <C-h>  getcharsearch().forward ? ',' : ';'
noremap <expr>  <C-l>  getcharsearch().forward ? ';' : ','

nnoremap  <space>/  <Cmd>nohlsearch<CR>
nnoremap  gx  <ScriptCmd>mf.OpenPath()<CR>
nnoremap  zS  <ScriptCmd>mf.Synnames()<CR>
nnoremap  <space>q  <Cmd>cnext<CR>
nnoremap  <space><C-q>  <Cmd>cprevious<CR>
nnoremap  <C-@><C-q>  <Cmd>cprevious<CR>
nnoremap  <space>a  <C-^>
nnoremap  <space>y  "+y
nnoremap  <space>Y  "+y$
nnoremap  <space>p  "+
nnoremap  <C-j>  <C-d>
nnoremap  <C-k>  <C-u>
nnoremap  <C-n>  <ScriptCmd>mypopup.ScrollDownOrJumpNextHunk()<CR>
nnoremap  <C-p>  <ScriptCmd>mypopup.ScrollUpOrJumpPrevHunk()<CR>
nnoremap  w  <C-w>w
nnoremap  q  <C-w>c
nnoremap  o  <C-w>o
nnoremap  f  <ScriptCmd>endofline.Toggle(';')<CR>
nnoremap  2  <ScriptCmd>mf.ToggleQfWindow()<CR>
nnoremap  3  <ScriptCmd>mf.ToggleLoclistWindow()<CR>
nnoremap  yow  <ScriptCmd>unimpaired.ToggleOption('wrap')<CR>
nnoremap  yoc  <ScriptCmd>unimpaired.ToggleOption('cursorline')<CR>
nnoremap  yox  <ScriptCmd>unimpaired.ToggleOption('cursorcolumn')<CR>
nnoremap  yos  <ScriptCmd>unimpaired.ToggleOption('spell')<CR>
nnoremap  yop  <ScriptCmd>unimpaired.ToggleOption('paste')<CR>
nnoremap  yol  <ScriptCmd>unimpaired.ToggleOption('list')<CR>
nnoremap  yof  <ScriptCmd>unimpaired.SwitchOption('foldcolumn', 0, 1)<CR>
nnoremap  yoy  <ScriptCmd>unimpaired.SwitchOption('colorcolumn', '', 100)<CR>
nnoremap  [<space>  <ScriptCmd>unimpaired.PasteBlanklineAbove()<CR>
nnoremap  ]<space>  <ScriptCmd>unimpaired.PasteBlanklineBelow()<CR>
nnoremap  <C-@><C-@>  <Cmd>let &iminsert = !&iminsert<CR>
nnoremap  `  <ScriptCmd>myterm.Toggle()<CR>

vnoremap  <C-j>  <C-d>
vnoremap  <C-k>  <C-u>
vnoremap  <space>y  "+y

noremap!  <C-@>  <Cmd>let &iminsert = !&iminsert<CR><C-^>
inoremap  k  <C-k>
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
tnoremap  `  <ScriptCmd>myterm.Toggle()<CR>
tnoremap  <C-q><C-n>  <C-q>N
tnoremap  <C-q>;  <C-q>:
tnoremap  <C-]>  <C-q>N

# Fix slow esc, should be after all Alt remaps
nnoremap <nowait>  <Esc>  <ScriptCmd>mypopup.ClosePopupOrPvwOrPressEsc()<CR>
inoremap <nowait>  <Esc>  <Esc>
xnoremap <nowait>  <Esc>  <Esc>
snoremap <nowait>  <Esc>  <C-c>
cnoremap <nowait>  <Esc>  <C-c>
tnoremap <nowait>  <Esc>  <Esc>

# example ':Time 50 call str2nr(102)'
command! -nargs=1 -complete=command Time mf.PrintTime(<q-args>)
