vim9script noclear

import autoload '../autoload/custom/on_yank.vim'

&history = 300
&display = 'truncate'
&incsearch = true
&langremap = false
&nrformats = 'bin,hex'
&mouse = 'a'

if !has('gui_running')
  # set termguicolors
  &t_ut = ''
  colorscheme boa
  &t_cl = ''
  &t_AU = "\e[58:5:%dm"
  &t_SI = "\e[6 q"
  &t_SR = "\e[4 q"
  &t_EI = "\e[2 q"
  &t_fe = "\e[?1004h"
  &t_fd = "\e[?1004l"
endif

&showmode = false
&ttimeout = true
&timeoutlen = 3000
&ttimeoutlen = 0
&signcolumn = 'yes'
&encoding = 'utf-8'
&formatoptions = 'jtcroql'
&autoindent = true
&startofline = false
&hlsearch = true

&laststatus = 2
&ruler = false

&autoread = true
&title = true
&hidden = true
&spelllang = 'en_us,ru_yo'
&updatetime = 250
&path = '.,,'

&pumheight = 10
&pumwidth = 20

&wrap = false
&number = true
&relativenumber = true
&ignorecase = true
&smartcase = true

&scrolloff = 5
&sidescrolloff = 5
&sidescroll = 1

&swapfile = false
&undofile = true
&undodir = $'{$HOME}/.cache/vim/undo'
# &viewoptions = 'cursor,curdir,folds'

&linebreak = true
&showbreak = '└'
&list = true
&listchars = 'tab:→-,trail:·,extends:⌇,precedes:⌇,nbsp:~'
&fillchars = 'eob: ,vert:┃'

&splitbelow = true
&splitright = true

&backspace = 'indent,eol,start'
&smarttab = true
&expandtab = true
&smartindent = true
&shiftround = true
&shiftwidth = 4
&softtabstop = -1
&joinspaces = false

&completeopt = 'menuone,noinsert,noselect,popup'
&completepopup = 'align:menu,border:off'
# &previewpopup = 'height:12,width:80'
&wildmenu = true
&wildmode = 'longest:full'
&wildoptions = 'fuzzy,pum'
&wildignorecase = true
&wildignore = '*/.git/*,*/__pycache__/*,*.pyc,*/node_modules/*' ..
              ',*.jpg,*.jpeg,*.bmp,*.gif,*.png,*.mp3,*.mp4' ..
              ',*.bak,*.sw[a-p],*~,*.lock,tags'
&wildcharm = &wildchar

&shortmess = 'filnrxtToOFIcs'
&diffopt = 'internal,filler,closeoff' ..
           ',algorithm:patience,context:3,foldcolumn:1' ..
           ',followwrap,hiddenoff,indent-heuristic,vertical'
&guicursor = ''
&keymap = 'russian-jcuken'
&iminsert = 0

&grepprg = 'rg\ --vimgrep'
&grepformat = '%f:%l:%c:%m'
&errorformat ..= ',%f\|%\s%#%l col%\s%#%c%\s%#\| %m'

&clipboard = 'exclude:cons\|linux'
&shell = '/bin/fish'

def JumpToLastPosition()
  const last_pos = getpos("'\"")
  if last_pos[1] >= 1 && last_pos[1] <= line('$')
    setpos('.', getpos("'\""))
  endif
enddef

# autocmds
augroup MyAutocmds
  autocmd!
  autocmd FocusGained * silent! checktime
  autocmd TerminalWinOpen * setlocal nonu nornu nolist signcolumn=no
  autocmd TextYankPost * on_yank.Highlight(250)
  autocmd BufReadPost * JumpToLastPosition()
augroup END

g:python_highlight_all = 1
g:markdown_folding = 0

# disable built-in plugins {{{1
g:loaded_getscriptPlugin = 1
g:loaded_gzip = 1
g:loaded_logiPat = 1
# Do not disable netrw so commands like :GBrowse would work
# g:loaded_netrw = 1
# g:loaded_netrwPlugin = 1
g:loaded_rrhelper = 1
g:loaded_spellfile_plugin = 1
g:loaded_tarPlugin = 1
g:loaded_2html_plugin = 1
g:loaded_vimballPlugin = 1
g:loaded_zipPlugin = 1
