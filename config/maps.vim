vim9script noclear

import autoload '../autoload/myfunctions.vim' as mf
import autoload '../autoload/custom/unimpaired.vim'
import autoload '../autoload/custom/endofline.vim'
import autoload '../autoload/mypopup.vim'
import autoload '../autoload/myterm.vim'

g:mapleader = ","

noremap  ;  :
map  Q  gq
sunmap Q
noremap  Y  y$
noremap <expr>  <C-h>  getcharsearch().forward ? ',' : ';'
noremap <expr>  <C-l>  getcharsearch().forward ? ';' : ','

if !!exists(':LF')
  nnoremap <A-1> <Cmd>LF<CR>
endif

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
nnoremap  <A-w>  <C-w>w
nnoremap  <A-q>  <C-w>c
nnoremap  <A-o>  <C-w>o
nnoremap  <A-f>  <ScriptCmd>endofline.Toggle(';')<CR>
nnoremap  <A-2>  <ScriptCmd>mf.ToggleQfWindow()<CR>
nnoremap  <A-3>  <ScriptCmd>mf.ToggleLoclistWindow()<CR>
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
nnoremap  <A-`>  <ScriptCmd>myterm.Toggle()<CR>
nnoremap <nowait>  <Esc>  <ScriptCmd>mypopup.ClosePopupOrPvwOrPressEsc()<CR>

vnoremap  <C-j>  <C-d>
vnoremap  <C-k>  <C-u>
vnoremap  <space>y  "+y

noremap!  <C-@>  <Cmd>let &iminsert = !&iminsert<CR><C-^>
inoremap  <A-k>  <C-k>
inoremap  <C-u>  <C-g>u<C-u>
inoremap  <A-h>  <Left>
inoremap  <A-l>  <Right>
inoremap  <A-f>  <Del>

cnoremap  <C-n>  <Down>
cnoremap  <C-p>  <Up>
cnoremap  <A-h>  <Left>
cnoremap  <A-l>  <Right>
cnoremap <expr>  <C-l>  pumvisible() ? "\<C-y>" : "\<CR>"
cnoremap <expr>  <C-j>  pumvisible() ? "\<C-n>" : "\<C-i>"
cnoremap <expr>  <C-k>  pumvisible() ? "\<C-p>" : "\<C-i>"

set termwinkey=<C-q>
tnoremap  <A-w>  <C-q>w
tnoremap  <A-q>  <Cmd>close!<CR>
tnoremap  <A-`>  <ScriptCmd>myterm.Toggle()<CR>
tnoremap  <C-q><C-n>  <C-q>N
tnoremap  <C-q>;  <C-q>:
tnoremap  <C-]>  <C-q>N

if !has('gui_running')
  # Fix Alt maps
  def InitAltMaps(keys: list<string>)
    def ImitateUnmap(alt_key: string, mode: string)
      if empty(maparg(alt_key, mode, false, true))
        exe $'{mode}map <expr> {alt_key} ""'
      endif
    enddef

    var alt_key: string
    for key in keys
      alt_key = $'<A-{key}>'
      exe $"set {alt_key}=\e{key}"
      ImitateUnmap(alt_key, 'i')
      ImitateUnmap(alt_key, 'c')
      if empty(maparg(alt_key, 't', false, true))
        exe $'tnoremap {alt_key} <esc>{key}'
      endif
    endfor
  enddef

  const alt_keys = ['`', '1', '2', '3', '4', 'q', 'w', 'f', 'k', 'h', 'l', 'o', 'a', 'e', 'p', 'b', 'n', 'r', 's', 'i', "'", '"']
  InitAltMaps(alt_keys)
endif

# example ':Time 50 call str2nr(102)'
command! -nargs=1 -complete=command Time mf.PrintTime(<q-args>)
