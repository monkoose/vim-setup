" coc.nvim and coc-fzf {{{
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
" fzf.vim {{{
let s:fzf_defaults = [
        \ '--ansi --bind="ctrl-/:toggle-preview,alt-i:toggle-all,ctrl-n:preview-page-down,ctrl-p:preview-page-up,ctrl-l:accept,' ..
          \ 'ctrl-r:clear-screen,alt-k:next-history,alt-j:previous-history,ctrl-alt-j:page-down,ctrl-alt-k:page-up"',
      \ '--color=hl:#f158a6,fg+:#b8af96,hl+:#f158a6,bg+:#3b312b,border:#40362f,gutter:#21261d,pointer:#d3c94b,prompt:#c57c41,marker:#d24b98,info:#70a17c',
      \ '--pointer=● --marker=▶ --layout=reverse --tabstop=2 --info=inline --margin=1,3 --exact --header='
      \ ]
let $FZF_DEFAULT_OPTS = join(s:fzf_defaults, " ")
let g:fzf_command_prefix = 'Fzf'
let g:fzf_history_dir = '~/.cache/vim/fzf_history'
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.7, 'border': 'none' } }

nnoremap <silent> <space>ff   <Cmd>FzfFiles<CR>
nnoremap <silent> <space>fh   <Cmd>FzfHelptags<CR>
nnoremap <silent> <space>fm   <Cmd>FzfMaps<CR>
nnoremap <silent> <space>;    <Cmd>FzfBuffers<CR>
nnoremap <silent> <space>ss   <Cmd>FzfRg<CR>
nnoremap <silent> <space>sb   <Cmd>FzfBLines<CR>
nnoremap <silent> <space>sw   :<C-u>FzfRg <C-r><C-w><CR>
nnoremap <silent> <space>gc   <Cmd>FzfCommits<CR>
nnoremap <silent> <space>gC   <Cmd>FzfBCommits<CR>


" }}}
" fzf-hoogle.vim {{{
augroup HoogleMaps
  autocmd!
  autocmd FileType haskell nnoremap <buffer>   <space>hh <Cmd>Hoogle <C-r><C-w><CR>
augroup END
let g:hoogle_fzf_header = ''
let g:hoogle_fzf_preview = 'down:50%:wrap'
let g:hoogle_count = 100
let g:hoogle_fzf_window = { 'right': '40%' }
" }}}
" undotree {{{
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout       = 2
let g:undotree_ShortIndicators    = 1
let g:undotree_HelpLine           = 0
nmap    <silent>    4    <Cmd>UndotreeToggle<CR>
" }}}
" vim-easy-align {{{
vmap    <Enter>    <Plug>(EasyAlign)
" }}}
" vim-fugitive {{{
nnoremap    <space>gg    <Cmd>Git<CR>
nnoremap    <space>gb    <Cmd>Git blame<CR>
nnoremap    <space>gd    <Cmd>Git diff<CR>
nnoremap    <space>ge    <Cmd>Git edit<CR>
" }}}
" vim-gista {{{
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
" vim-gitgutter {{{
let g:gitgutter_sign_modified_removed  = '≃'

nmap  <silent>   <space>gi <Plug>(GitGutterPreviewHunk)
nmap  <silent>   <space>guu <Plug>(GitGutterUndoHunk)
nmap  <silent>   <space>gss <Plug>(GitGutterStageHunk)

augroup GitGutterUpdate
  autocmd!
  autocmd BufWritePost * GitGutter
augroup END
" }}}
" vim9-stargate {{{
noremap <space><space> <Cmd>call stargate#ok_vim(1)<CR>

let g:stargate_keymaps = {
      \ "~": "Ё",
      \ "Q": "Й", "W": "Ц", "E": "У", "R": "К", "T": "Е", "Y": "Н", "U": "Г", "I": "Ш", "O": "Щ", "P": "З", "{": "Х", "}": "Ъ",
      \  "A": "Ф", "S": "Ы", "D": "В", "F": "А", "G": "П", "H": "Р", "J": "О", "K": "Л", "L": "Д", ":": "Ж", '"': "Э",
      \   "Z": "Я", "X": "Ч", "C": "С", "V": "М", "B": "И", "N": "Т", "M": "Ь", "<": "Б", ">": "Ю",
      \ "`": "ё",
      \ "q": "й", "w": "ц", "e": "у", "r": "к", "t": "е", "y": "н", "u": "г", "i": "ш", "o": "щ", "p": "з", "[": "х", "]": "ъ",
      \  "a": "ф", "s": "ы", "d": "в", "f": "а", "g": "п", "h": "р", "j": "о", "k": "л", "l": "д", ";": "ж", "'": "э",
      \   "z": "я", "x": "ч", "c": "с", "v": "м", "b": "и", "n": "т", "m": "ь", ",": "б", ".": "ю"
      \ }
" }}}

" vim: foldmethod=marker
