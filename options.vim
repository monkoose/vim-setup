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
"set viewoptions=cursor,curdir,folds
set linebreak
set showbreak=└
set list listchars=tab:→-,trail:·,extends:⌇,precedes:⌇,nbsp:~
set fillchars=vert:█,fold:·
set noruler
set splitbelow splitright
set smarttab expandtab smartindent shiftround shiftwidth=2 softtabstop=-1
set nojoinspaces
set completeopt=menuone,longest,noinsert,noselect,popup
set wildignore+=*/.git/*,*/__pycache__/*,*.pyc
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png
set wildignorecase
set shortmess=filnrxtToOFIc
set diffopt=filler,vertical,closeoff
set guicursor=
set keymap=russian-jcuken iminsert=0
set grepprg=rg\ --vimgrep grepformat=%f:%l:%c:%m
set clipboard-=autoselect

let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logiPat = 1
let g:loaded_rrhelper = 1
let g:loaded_tarPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zipPlugin = 1
let g:python_highlight_all = 1
let g:markdown_folding = 0

" let g:loaded_netrwPlugin = 1
let g:netrw_use_errorwindow = 0
let g:netrw_winsize = 20
let g:netrw_sizestyle = 'H'
let g:netrw_list_hide = netrw_gitignore#Hide() .. ',.git/'
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_wiw = 15
