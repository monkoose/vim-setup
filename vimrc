" PLUGINS {{{
" Source defaults.vim
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

call plug#begin('~/.vim/plugged')
Plug 'monkoose/boa-vim.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'neovimhaskell/haskell-vim', {'for': ['haskell']}
Plug 'tbastos/vim-lua', {'for': ['lua']}
Plug 'Vimjas/vim-python-pep8-indent', {'for': ['python']}
Plug 'hail2u/vim-css3-syntax'
Plug 'cakebaker/scss-syntax.vim'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'honza/vim-snippets'
Plug 'monkoose/vim-stargate'
Plug 'wellle/targets.vim'
Plug 'cespare/vim-toml', {'for': ['toml']}
Plug 'evanleck/vim-svelte', {'for': ['svelte']}

" PLUGINS WITH CUSTOM CONFIG
Plug 'neoclide/coc.nvim'
Plug 'antoinemadec/coc-fzf'
Plug 'junegunn/fzf.vim'
Plug 'monkoose/fzf-hoogle.vim'
" Plug 'Raimondi/delimitMate'
Plug 'Lenovsky/nuake', {'on': 'Nuake'}
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'junegunn/vim-easy-align', {'on': '<Plug>(EasyAlign)'}
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'lambdalisue/vim-gista', {'on': 'Gista'}
Plug 'airblade/vim-gitgutter'
call plug#end()

"}}}
" PLUGINS CONFIG {{{
" neoclide/coc.nvim antoinemadec/coc-fzf {{{
let g:coc_global_extensions = [
      \ 'coc-vimlsp',
      \ 'coc-json',
      \ 'coc-sh',
      \ 'coc-snippets',
      \ 'coc-pyright',
      \ 'coc-tsserver',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-yaml',
      \ 'coc-svelte',
      \ 'coc-clangd',
      \ ]

let g:coc_snippet_next = 'e'
let g:coc_snippet_prev = 'r'
inoremap <silent><expr>   <C-l>     pumvisible() ? coc#_select_confirm() : coc#refresh()
inoremap <silent><expr>   <C-j>     pumvisible() ? "\<C-n>" : coc#refresh()
inoremap <silent><expr>   <C-k>     pumvisible() ? "\<C-p>" : coc#refresh()
inoremap <silent>         <CR>      <C-g>u<CR><C-r>=coc#on_enter()<CR>

nmap     <silent>         <space>kk   <Cmd>CocRestart<CR>
nmap     <silent>         <space>D    <Plug>(coc-declaration)
nmap     <silent>         <space>kr   <Plug>(coc-references)
nmap     <silent>         <space>kR   <Plug>(coc-rename)
nmap     <silent>         <space>ka   <Cmd>CocFzfList actions<CR>
nmap     <silent>         <space>kd   <Cmd>CocFzfList diagnostics<CR>
nmap     <silent>         <space>kl   <Cmd>CocFzfList<CR>
nmap     <silent>         <space>kf   <Plug>(coc-format)
nmap     <silent>         <space>ki   <Plug>(coc-diagnostic-info)
nmap     <silent>         <space>ko   <Cmd>CocFzfList outline<CR>
vmap     <silent>         <space>ka   <Plug>(coc-codeaction-selected)
vmap     <silent>         <space>kf   <Plug>(coc-format-selected)

augroup CocAutocmd
  autocmd!
  autocmd FileType css,scss,javascript,typescript,html,python,haskell,json,yaml,vim,svelte,sh,c,lua
        \ call s:define_coc_mappings()
  autocmd FileType haskell vmap <buffer><silent> K <Cmd>call CocActionAsync('doHover')<CR>
augroup END

function! s:define_coc_mappings() abort
  nnoremap <buffer><silent> K        <Cmd>call CocActionAsync('doHover')<CR>
  nmap     <buffer><silent> <space>d <Plug>(coc-definition)
  nmap     <buffer>         <space>l <Plug>(coc-diagnostic-next)
  nmap     <buffer>         <space>L <Plug>(coc-diagnostic-prev)
endfunction
"}}}
" Raimondi/delimitMate {{{
" let g:delimitMate_expand_cr    = 1
" let g:delimitMate_expand_space = 1

" augroup DelimitMatePython
"   autocmd!
"   autocmd FileType python let b:delimitMate_nesting_quotes = ['"']
" augroup END
"}}}
" fzf-hoogle.vim {{{
augroup HoogleMaps
  autocmd!
  autocmd FileType haskell nnoremap <buffer>   <space>hh <Cmd>Hoogle <C-r><C-w><CR>
augroup END
let g:hoogle_fzf_header = ''
let g:hoogle_fzf_preview = 'down:50%:wrap'
let g:hoogle_count = 100
" }}}
" fzf.vim {{{
let s:fzf_defaults = [
        \ '--ansi --bind="ctrl-/:toggle-preview,alt-i:toggle-all,ctrl-n:preview-page-down,ctrl-p:preview-page-up,ctrl-l:accept,' ..
          \ 'ctrl-r:clear-screen,alt-k:next-history,alt-j:previous-history,ctrl-alt-j:page-down,ctrl-alt-k:page-up"',
      \ '--color=hl:#f158a6,fg+:#b8af96,hl+:#f158a6,bg+:#3b312b,border:#40362f,gutter:#21261d,pointer:#d3c94b,prompt:#c57c41,marker:#d24b98,info:#70a17c',
      \ '--pointer=● --marker=▶ --layout=reverse --tabstop=2 --info=inline --margin=1,3 --exact --header='
      \ ]
let $FZF_DEFAULT_OPTS = join(s:fzf_defaults, " ")
let g:fzf_command_prefix = 'Fzf'

nnoremap <silent> <space>ff   <Cmd>FzfFiles<CR>
nnoremap <silent> <space>;    <Cmd>FzfBuffers<CR>
nnoremap <silent> <space>ss   <Cmd>FzfRg<CR>
nnoremap <silent> <space>sb   <Cmd>FzfBLines<CR>
nnoremap <silent> <space>sw   :<C-u>FzfRg <C-r><C-w><CR>
nnoremap <silent> <space>gc   <Cmd>FzfCommits<CR>
nnoremap <silent> <space>gC   <Cmd>FzfBCommits<CR>

" }}}
" Lenovsky/nuake {{{
let g:nuake_size = 0.40

nnoremap    <silent>    `        <Cmd>Nuake<CR>
tnoremap    <silent>    `        <Cmd>Nuake<CR>
" }}}
" mbbill/undotree {{{
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout       = 2
let g:undotree_ShortIndicators    = 1
let g:undotree_HelpLine           = 0
nmap    <silent>    4    <Cmd>UndotreeToggle<CR>
" }}}
" junegunn/vim-easy-align {{{
vmap    <Enter>    <Plug>(EasyAlign)
" }}}
" easymotion/vim-easymotion {{{
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1
let g:EasyMotion_verbose = 0
let g:EasyMotion_use_upper = 1
let g:EasyMotion_keys = 'ACDEFGHIJKLMNOPRSUVW'

map <silent> ,              <Plug>(easymotion-s)
map <silent> <space><space> <Plug>(easymotion-s)
" }}}
" tpope/vim-fugitive {{{
nnoremap    <space>gg    <Cmd>Git<CR>
nnoremap    <space>gb    <Cmd>Git blame<CR>
nnoremap    <space>gd    <Cmd>Git diff<CR>
nnoremap    <space>ge    <Cmd>Git edit<CR>
" }}}
" lambdalisue/vim-gista {{{
let g:gista#client#default_username = "monkoose"
let g:gista#command#list#enable_default_mappings = 0
let g:gista#command#commits#enable_default_mappings = 0
let g:gista#command#list#show_status_string_in_prologue = 0
let g:gista#command#commits#show_status_string_in_prologue = 0
nnoremap    <space>gl     <Cmd>Gista list<CR>
nnoremap    <space>gp     :<C-u>Gista post -P -d=""<Left>

augroup GistaBuffer
  autocmd!
  autocmd FileType gista-list,gista-commits call s:define_gista_mappings()
augroup END

function! s:define_gista_mappings() abort
  nmap <buffer> q <Plug>(gista-quit)
  nmap <buffer> <C-n> <Plug>(gista-next-mode)
  nmap <buffer> <C-p> <Plug>(gista-prev-mode)
  nmap <buffer> ? <Plug>(gista-toggle-mapping-visibility)
  nmap <buffer> <C-r> <Plug>(gista-redraw)
  nmap <buffer> <F5>   <Plug>(gista-update)
  nmap <buffer> r <Plug>(gista-UPDATE)
  map <buffer> <Return> <Plug>(gista-edit-tab)
  map <buffer> <C-l> <Plug>(gista-edit-tab)
  map <buffer> bb <Plug>(gista-browse-open)
  map <buffer> yy <Plug>(gista-browse-yank)
  map <buffer> rr <Plug>(gista-rename)
  map <buffer> df <Plug>(gista-remove)
  map <buffer> dd <Plug>(gista-delete)
  map <buffer> ++ <Plug>(gista-star)
  map <buffer> -- <Plug>(gista-unstar)
  map <buffer> ff <Plug>(gista-fork)
  map <buffer> cc <Plug>(gista-commits)
endfunction
" }}}
" airblade/vim-gitgutter {{{
let g:gitgutter_sign_modified_removed  = '≃'

nmap  <silent>   <space>gi <Plug>(GitGutterPreviewHunk)
nmap  <silent>   <space>guu <Plug>(GitGutterUndoHunk)
nmap  <silent>   <space>gss <Plug>(GitGutterStageHunk)

augroup GitGutterUpdate
  autocmd!
  autocmd BufWritePost * GitGutter
augroup END
" }}}
"}}}
" OPTIONS {{{

set background=dark
colorscheme boa
source /usr/share/vim/vimfiles/plugin/fzf.vim

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
set noswapfile undofile undodir=~/.vim/undo-files/
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
set shortmess=filnrxtToOFIc
set diffopt=filler,vertical,closeoff
set guicursor=
set keymap=russian-jcukenwin iminsert=0
set grepprg=rg\ --vimgrep grepformat=%f:%l:%c:%m

let g:markdown_folding = 1
let g:loaded_netrwPlugin = 1
let g:python_highlight_all = 1
let g:loaded_2html_plugin = 1
let g:loaded_gzip = 1
let g:loaded_tarPlugin = 1
let g:loaded_zipPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_rrhelper = 1
let g:loaded_logiPat = 1
" runtime ftplugin/man.vim

" check for changed files outside of neovim {{{
augroup CheckTime
  autocmd!
  autocmd FocusGained * silent! checktime
augroup END
"}}}
" FileType config {{{
augroup FileTypeOptions
  autocmd!
  autocmd FileType * syntax sync maxlines=100
  autocmd FileType qf        setlocal wrap
  autocmd FileType vim       setlocal iskeyword-=#
  autocmd FileType css,scss  setlocal iskeyword+=-
  autocmd FileType haskell   setlocal shiftwidth=4
  autocmd FileType gitcommit setlocal spell | startinsert
  autocmd FileType fugitive nmap <buffer> <C-l> =
augroup END
"}}}
" Statusline {{{
set statusline=%{InitializeSL()}

let s:git       = "%1*%{StatusGitBranch()}%*%4*%{StatusGitCommit()}%*%3*%{StatusGitGutter()}%*"
let s:refresh   = "%{RefreshSL(&modified)}"
let s:spell     = "%5*%{&spell ? '  SPELL ' : ''}%*"
let s:lncol     = "%< %-9(%3*%l%*·%4*%c%V%*%) "
let s:tail      = " %=%Y  %4*%P%* "
let s:fname     = "  %f "
let s:fname_mod = "  %2*%f%* "
let s:ro        = "%6*%{&ro ? '' : ''}%*  "
let s:iminsert  = "%6*%{StatusIminsert()}%*"

" session - %{fnamemodify(v:this_session, ':t')}
function! InitializeSL() abort
  let statusline = s:iminsert .. s:fname .. s:ro .. s:git .. s:spell .. s:tail .. s:refresh
  call setwinvar(winnr(), '&statusline', statusline)
  return ''
endfunction

function! RefreshSL(mod) abort
  let slmod = getwinvar(winnr(), 'statusline_mod', 0)
  if a:mod != slmod
    let filename = a:mod ? s:fname_mod : s:fname
    if slmod
      call setwinvar(winnr(), 'statusline_mod', 0)
    else
      call setwinvar(winnr(), 'statusline_mod', 1)
    endif
    let statusline = s:iminsert .. filename .. s:ro .. s:git .. s:spell .. s:tail .. s:refresh
    call setwinvar(winnr(), '&statusline', statusline)
  endif
  return ''
endfunction

augroup SetStatusLine
  autocmd!
  autocmd FileType fugitiveblame let &l:statusline='%< %(%l/%L%) %=%P '
  autocmd TerminalWinOpen * let &l:statusline='  %f %=%Y '
augroup END

function! StatusGitBranch() abort
  let dir = FugitiveGitDir(bufnr(''))
  if empty(dir)
    return ''
  endif
  return ' ' .. FugitiveHead(7, dir)
endfunction

function! StatusGitCommit() abort
  let commit = matchstr(@%, '\c^fugitive:\%(//\)\=.\{-\}\%(//\|::\)\zs\%(\x\{40,\}\|[0-3]\)\ze\%(/.*\)\=$')
  if len(commit)
    let commit = '·' .. commit[0:6]
  endif
  return commit .. ' '
endfunction

function! StatusGitGutter() abort
  let symbols = ['+', '~', '-']
  let changes = join(map(copy(GitGutterGetHunkSummary()), "v:val == 0 ? '' : ' ' .. symbols[v:key] .. v:val"), '')
  return changes
  " return winwidth(winnr()) > 60 ? changes : ''
endfunction

function! StatusIminsert() abort
  return &iminsert ? '   RU ' : ''
endfunction
"}}}
"}}}

let s:config_dir = expand('<sfile>:p:h') .. '/'
execute 'source ' .. s:config_dir .. 'vim9.vim'

" MAPS {{{
set pastetoggle=<F2>
noremap            Q           gq
nnoremap <silent>  <F3>        <Cmd>setlocal spell!<CR>
nnoremap <silent>  <space>/    <Cmd>nohlsearch<CR>
nnoremap           w         <C-w>w
nnoremap <silent>  f         <Cmd>call <SID>InsertSemiColon()<CR>
nnoremap <silent>  <C-n>       <Cmd>call <SID>ScrollDownNextHunk()<CR>
nnoremap <silent>  <C-p>       <Cmd>call <SID>ScrollUpPrevHunk()<CR>
nnoremap <silent>  2         <Cmd>call <SID>ToggleQf()<CR>
nnoremap <silent>  3         <Cmd>call <SID>ToggleLocList()<CR>
nnoremap <silent>  gx          <Cmd>call <SID>OpenPath(expand('<cfile>'))<CR>
nnoremap <silent>  zS          <Cmd>call <SID>SynNames()<CR>
nnoremap           <space>q    <Cmd>pclose<CR>
nnoremap <silent>  <space>a    <Cmd>b#<CR>
nnoremap           <space>d    <C-]>
nnoremap           <space>y    "+y
nnoremap           <space>p    "+
nnoremap           <C-j>       <C-d>
nnoremap           <C-k>       <C-u>
nnoremap <silent>  H           <Cmd>bn<CR>
nnoremap <silent>  L           <Cmd>bp<CR>
nnoremap           q         <C-w>c
nnoremap           o         <C-w>o
nnoremap <silent>  yof         <Cmd>let &foldcolumn = !&foldcolumn<CR>
nnoremap <silent>  yoy         <Cmd>let &cc = &cc == '' ? 100 : ''<CR>
nnoremap <silent>  <C-@>       <Cmd>let &iminsert = !&iminsert<CR>
nnoremap           ;           :
nnoremap           <C-h>       ,
nnoremap           <C-l>       ;

vnoremap           <space>y    "+y
vnoremap           <C-j>       <C-d>
vnoremap           <C-k>       <C-u>
vnoremap           ;           :
vnoremap           <C-h>       ,
vnoremap           <C-l>       ;

noremap!           <C-space>   <C-^>
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
tnoremap <silent>  q       <C-q>c

" Show syntax names {{{
function! s:SynNames() abort
  let synlist = reverse(map(synstack(line('.'), col('.')), 'synIDattr(v:val,"name")'))
  echo ' ' .. join(synlist, ' ')
endfunction
"}}}
" TTime count command {{{
" usage :TTime `times to execute` `any vim command`
" example :TTime 300 call str2nr('3')
function! s:Timer(arg) abort
  let [times; cmd] = split(a:arg)
  let cmd = join(cmd)
  let time = reltime()
  try
    for i in range(times)
      execute cmd
    endfor
  finally
    let result = reltimefloat(reltime(time))
    redraw
    echomsg ' ' .. string(result * 1000) .. 'ms to run :' .. cmd
  endtry
  return ''
endfunction
command! -nargs=1 -complete=command TTime execute s:Timer(<q-args>)
"}}}
" OpenPath() {{{
function! s:OpenPath(path) abort
  call job_start(['xdg-open', a:path])
  echohl String
  echo "Open "
  echohl Identifier
  echon a:path
  echohl None
endfunction
"}}}
" Toggle Location and QuickFix lists {{{
function! s:ToggleLocList() abort
  let is_loclist = getwininfo(win_getid())[0].loclist
  if is_loclist
    exec winnr('#') .. "wincmd w"
    lclose
    return
  endif
  try
    lopen
  catch /E776/
      echohl WarningMsg
      echo "Location List is empty"
      echohl None
      return
  endtry
endfunction

function! s:ToggleQf() abort
  let is_qf = getwininfo(win_getid())[0].quickfix
  for win in getwininfo()
    if win.quickfix && !win.loclist
      if is_qf
        exec winnr('#') .. "wincmd w"
      endif
      cclose
      return
    endif
  endfor
  botright copen
endfunction
"}}}
" PreviewWindowNr() {{{
function! s:PreviewWindowNr(winnrs) abort
  for nr in a:winnrs
    if getwinvar(nr, '&pvw')
      return nr
    endif
  endfor
  return 0
endfunction
"}}}
" PopupWindowID() {{{
function! s:PopupWindowID() abort
  let cursor_pos = screenpos(win_getid(), line('.'), col('.'))
  let popup_window = popup_locate(cursor_pos.row + 1, cursor_pos.col)
  if !popup_window
    let popup_window = popup_locate(cursor_pos.row - 1, cursor_pos.col)
  endif
  return popup_window
endfunction
" }}}
" ClosePopupWindow() {{{
function! s:ClosePopupWindow() abort
  let popup_winid = s:PopupWindowID()
  if popup_winid
    call popup_close(popup_winid)
  else
    execute "normal! \<Esc>"
  endif
endfunction
" }}}
" ScrollPopupWindow() {{{
function! s:ScrollPopupWindow(winid, step) abort
  let popup_info = popup_getpos(a:winid)
  if !popup_info.scrollbar
    return
  endif
  let firstline = popup_getoptions(a:winid).firstline
  if a:step < 0 && firstline <= abs(a:step)
    call popup_setoptions(a:winid, {'firstline': 1})
  elseif a:step > 0 && firstline + a:step > popup_info.lastline
  else
    call popup_setoptions(a:winid, {'firstline': firstline + a:step})
  endif
endfunction
" }}}
" scroll preview window or jump to git changes {{{
function! s:CmdPvwOrCurrWin(cmd, curr_cmd) abort
  let winnrs = range(1, winnr('$'))
  let winnr = s:PreviewWindowNr(winnrs)
  let curr_win = winnr()
  if winnr != 0
    try
      execute winnr .. "wincmd w"
      execute a:cmd
    finally
      execute curr_win .. "wincmd w"
    endtry
  else
    execute a:curr_cmd
  endif
endfunction

function! s:ScrollDownNextHunk() abort
  let popup_winid = s:PopupWindowID()
  if popup_winid
    call s:ScrollPopupWindow(popup_winid, 5)
  else
    call s:CmdPvwOrCurrWin("normal! 3\<C-e>", "normal ]c")
  endif
endfunction

function! s:ScrollUpPrevHunk() abort
  let popup_winid = s:PopupWindowID()
  if popup_winid
    call s:ScrollPopupWindow(popup_winid, -5)
  else
    call s:CmdPvwOrCurrWin("normal! 3\<C-y>", "normal [c")
  endif
endfunction
"}}}
" insert ; at the end of a line if there is none {{{
function! s:InsertSemiColon() abort
  let view = winsaveview()
  if match(getline('.'), ';\_$') == -1
    execute 'keepp s/\_$/;/'
  else
    execute 'keepp s/;\_$//'
  endif
  call winrestview(view)
endfunction
"}}}

nnoremap <silent><nowait>  <Esc>     <Cmd>call <SID>ClosePopupWindow()<CR>
inoremap <nowait>          <Esc>     <Esc>
vnoremap <nowait>          <Esc>     <Esc>
cnoremap <nowait>          <Esc>     <C-c>
tnoremap <nowait>          <Esc>     <Esc>
"}}}
" vim: foldmethod=marker
