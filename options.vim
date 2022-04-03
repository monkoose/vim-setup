vim9script

set background=dark
colorscheme boa

set ttimeoutlen=50
set belloff=
set signcolumn=yes
set encoding=utf-8
set formatoptions=jtcroql
set autoindent
set nostartofline
set hlsearch
set laststatus=2
set autoread
set termguicolors
set title
set hidden
set spelllang=en_us,ru_yo
set pumheight=10
set nowrap
set number relativenumber
set ignorecase smartcase
set sidescrolloff=5 sidescroll=1
set updatetime=600
set noswapfile undofile undodir=~/.cache/vim/undo/
# set viewoptions=cursor,curdir,folds
set linebreak
set showbreak=└
set list listchars=tab:→-,trail:·,extends:⌇,precedes:⌇,nbsp:~
set fillchars=vert:█,fold:·
set noruler
set splitbelow splitright
set smarttab expandtab smartindent shiftround shiftwidth=4 softtabstop=-1
set nojoinspaces
set completeopt=menuone,longest,noinsert,noselect,popup
set wildmode=longest:full
set wildoptions=fuzzy,pum
set wildignore+=*/.git/*,*/__pycache__/*,*.pyc,*/node_modules/*
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png
set wildignorecase
set shortmess=filnrxtToOFIc
set diffopt=filler,vertical,closeoff
set guicursor=
set keymap=russian-jcuken iminsert=0
set grepprg=rg\ --vimgrep grepformat=%f:%l:%c:%m
set clipboard-=autoselect
set shell=/bin/fish

# autocmds
augroup MyAutocmds
  autocmd!
  autocmd FocusGained * silent! checktime
  autocmd TerminalWinOpen * setlocal nonumber norelativenumber
  autocmd FileType * syntax sync minlines=200
  autocmd TextYankPost * silent call custom#on_yank#Highlight(250)
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
