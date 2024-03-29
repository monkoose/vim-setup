vim9script noclear

import autoload '../autoload/custom/on_yank.vim'

syntax enable

&history = 300
&display = 'truncate'
# &incsearch = true
&langremap = false
&nrformats = 'bin,hex'
# &showcmd = true
&mouse = 'a'

if !has('gui_running')
  # set termguicolors
  colorscheme boa
  &t_ut = ''
  &t_cl = ''
  &t_AU = "\e[58:5:%dm"
  &t_SI = "\e[6 q"
  &t_SR = "\e[4 q"
  &t_EI = "\e[2 q"
  &t_fe = "\e[?1004h"
  &t_fd = "\e[?1004l"
endif

&synmaxcol = 1500
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
&writebackup = false

&laststatus = 2
&ruler = false

&autoread = true
&title = true
&titlestring = 'VIM: b%n L%L %a'
&hidden = true
&spelllang = 'en_us,ru_yo'
&updatetime = 300
&path = '.,,'

&pumheight = 5
&pumwidth = 20

&wrap = false
&number = true
&relativenumber = true
&ignorecase = true
&smartcase = true

&scrolloff = 5
&sidescrolloff = 5
&sidescroll = 1

&updatecount = 0
&swapfile = false
&undofile = true
&undodir = $'{$HOME}/.cache/vim/undo'
# &viewoptions = 'cursor,curdir,folds'

&linebreak = true
&showbreak = '└'
&list = true
&listchars = 'tab:→-,trail:·,extends:⌇,precedes:⌇,nbsp:~'
&fillchars = 'eob: ,vert:┃,fold: '

&splitbelow = true
&splitright = true

&backspace = 'indent,eol,start'
&smarttab = true
&expandtab = true
&smartindent = true
&shiftround = true
&tabstop = 4
&shiftwidth = 4
&softtabstop = -1
&joinspaces = false

&completeopt = 'menuone,noinsert,noselect,preview,popup'
&completepopup = 'align:menu,border:off'
# &previewpopup = 'height:12,width:80'
&wildmenu = true
&wildmode = 'longest:full'
&wildoptions = 'fuzzy,pum'
&wildignorecase = true
&wildignore = '*/.git/*,*/__pycache__/*,*.pyc,*/node_modules/*' ..
              ',*.jpg,*.jpeg,*.bmp,*.gif,*.png,*.mp3,*.mp4,*.mpv' ..
              ',*.bak,*.swap,*.swp,*~,*.lock,tags'
&wildcharm = &wildchar

&shortmess = 'filnrxtToOFIcs'
&diffopt = 'internal,filler,closeoff,algorithm:patience,context:3,foldcolumn:1,followwrap,hiddenoff,indent-heuristic,vertical'
&guicursor = ''
&keymap = 'russian-jcuken'
&iminsert = 0

&grepprg = 'rg --vimgrep'
&grepformat = '%f:%l:%c:%m'
&errorformat ..= ',%f\|%\s%#%l col%\s%#%c%\s%#\| %m'

&clipboard = 'exclude:cons\|linux'
&shell = '/bin/bash'

&ttyscroll = 9

# def GitignoreToWildignore(path: string): string
#   const gitignore = path .. '/.gitignore'
#   if filereadable(gitignore)
#     var wignore: list<string> = []
#     for oline in readfile(gitignore)
#       var line = substitute(oline, '\s|\n|\r', '', 'g')
#       line = substitute(line, ',', '\\\\,', 'g')
#       if line =~ '^#' | continue | endif
#       if line == ''   | continue | endif
#       if line =~ '^!' | continue | endif
#       if line =~ '/$'
#         add(wignore, line .. "*")
#         continue
#       endif
#       add(wignore, substitute(line, ' ', '\\ ', 'g'))
#     endfor
#     return ',' .. join(wignore, ',')
#   endif
#   return ''
# enddef

# # TODO: it keeps stacking wildignore on directory change
# def AdjustPath(_)
#   job_start(['git', 'rev-parse', '--show-toplevel'], {
#     out_cb: (_, mes) => {
#       if !empty(mes)
#         const path = getcwd() == mes ? '.' : fnameescape(mes)
#         var dirs: list<string>
#         job_start(['fd', '.', path, '--type=d', '--max-depth=1'], {
#           out_cb: (_, m) => {
#             add(dirs, m .. '**')
#           },
#           exit_cb: (_, _) => {
#             set path<
#             &path ..= join(dirs, ',')
#             set wildignore<
#             &wildignore ..= GitignoreToWildignore(path)
#           } })
#       endif
#     } })
# enddef

def JumpToLastPosition()
  const last_pos = getpos("'\"")
  if last_pos[1] >= 1 && last_pos[1] <= line('$')
    setpos('.', last_pos)
  endif
enddef

# autocmds
augroup MyAutocmds
  autocmd!
  autocmd FocusGained * silent! checktime
  autocmd TerminalWinOpen * setlocal nonu nornu nolist foldcolumn=0 signcolumn=no
  autocmd TextYankPost * on_yank.Highlight(250)
  autocmd BufReadPost * JumpToLastPosition()
  # autocmd VimEnter,DirChanged * timer_start(20, AdjustPath)
augroup END

g:python_highlight_all = 1
# g:markdown_folding = 1
g:diff_translations = false

# disable built-in plugins {{{1
g:loaded_getscriptPlugin = 1
g:loaded_gzip = 1
g:loaded_logiPat = 1
g:loaded_manpager_plugin = 1
g:loaded_rrhelper = 1
g:loaded_spellfile_plugin = 1
g:loaded_tarPlugin = 1
g:loaded_2html_plugin = 1
g:loaded_vimballPlugin = 1
g:loaded_zipPlugin = 1
g:loaded_matchparen = 1

g:vim_json_warnings = 0

# netrw
g:netrw_banner = 0
# g:netrw_list_hide = netrw_gitignore#Hide('~/.gitignore')
# g:netrw_liststyle = 3
g:netrw_winsize = 20
