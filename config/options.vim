vim9script

import autoload '../autoload/custom/on_yank.vim'

g:skip_defaults_vim = 1
set history=300
set showcmd
set display=truncate
set incsearch
set nrformats-=octal
set nolangremap

set t_ut=
if !has('gui_running')
  # set termguicolors
  colorscheme boa
  set t_cl=
  &t_AU = "\e[58:5:%dm"
  &t_SI = "\e[6 q"
  &t_SR = "\e[4 q"
  &t_EI = "\e[2 q"
  &t_fe = "\e[?1004h"
  &t_fd = "\e[?1004l"
endif

set noshowcmd
set noshowmode
set ttimeout
set ttimeoutlen=30
set belloff=
set signcolumn=yes
set encoding=utf-8
set formatoptions=jtcroql
set autoindent
set nostartofline
set hlsearch
set laststatus=2
set autoread
set title
set hidden
set spelllang=en_us,ru_yo
set pumheight=10 pumwidth=20
set nowrap
set number relativenumber
set ignorecase smartcase
set scrolloff=5 sidescrolloff=5 sidescroll=1
set updatetime=250
set noswapfile undofile undodir=~/.cache/vim/undo/
# set viewoptions=cursor,curdir,folds
set linebreak
set showbreak=└
set list listchars=tab:→-,trail:·,extends:⌇,precedes:⌇,nbsp:~
set fillchars=
set noruler
set splitbelow splitright
set backspace=indent,eol,start
set smarttab expandtab smartindent shiftround shiftwidth=4 softtabstop=-1
set nojoinspaces
set completeopt=menuone,longest,noinsert,noselect,popup
set completepopup=align:menu,border:off
set wildmenu wildmode=longest:full wildoptions=fuzzy,pum
set wildignorecase
set wildignore+=*/.git/*,*/__pycache__/*,*.pyc,*/node_modules/*
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png
set shortmess=filnrxtToOFIcs
set diffopt=filler,vertical,closeoff
set guicursor=
set keymap=russian-jcuken iminsert=0
set grepprg=rg\ --vimgrep grepformat=%f:%l:%c:%m
set clipboard-=autoselect
set shell=/bin/fish

def JumpToLastPosition()
  const last_pos = line("'\"")
  if last_pos >= 1 && last_pos <= line('$')
    exe 'normal! g`"'
  endif
enddef

# autocmds
augroup MyAutocmds
  autocmd!
  autocmd FocusGained * silent! checktime
  autocmd TerminalWinOpen * setlocal nonumber norelativenumber signcolumn=no nolist
  autocmd TextYankPost * on_yank.Highlight(250)
  autocmd BufReadPost * JumpToLastPosition()
augroup END

g:python_highlight_all = 1
g:markdown_folding = 0

# disable built-in plugins
g:loaded_getscriptPlugin = 1
g:loaded_gzip = 1
g:loaded_logiPat = 1
g:loaded_netrw = 1
g:loaded_netrwPlugin = 1
g:loaded_rrhelper = 1
g:loaded_spellfile_plugin = 1
g:loaded_tarPlugin = 1
g:loaded_2html_plugin = 1
g:loaded_vimballPlugin = 1
g:loaded_zipPlugin = 1
