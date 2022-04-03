vim9script

# coc.nvim and coc-fzf {{{
g:coc_global_extensions = [
  'coc-vimlsp',
  'coc-json',
  'coc-sh',
  'coc-snippets',
  'coc-pyright',
  'coc-tsserver',
  'coc-html',
  'coc-css',
  'coc-yaml',
  'coc-clangd',
  'coc-rust-analyzer',
  'coc-lua',
  'coc-fish',
]

g:coc_snippet_next = 'e'
g:coc_snippet_prev = 'w'
inoremap <silent> n <Cmd>call coc#float#scroll(1, 4)<CR>
inoremap <silent> p <Cmd>call coc#float#scroll(0, 4)<CR>
inoremap <silent><expr>   <C-l>     pumvisible() ? coc#_select_confirm() : coc#refresh()
inoremap <silent><expr>   <C-j>     pumvisible() ? "\<C-n>" : coc#refresh()
inoremap <silent><expr>   <C-k>     pumvisible() ? "\<C-p>" : coc#refresh()
inoremap <silent>         <CR>      <C-g>u<CR><C-r>=coc#on_enter()<CR>
inoremap <silent>         s         <Cmd>call CocActionAsync('showSignatureHelp')<CR>
nmap     <silent>         <space>kk   <Cmd>CocRestart<CR>
nmap     <silent>         <space>D    <Plug>(coc-declaration)
nmap     <silent>         <space>kr   <Plug>(coc-references)
nmap     <silent>         <space>kR   <Plug>(coc-rename)
nmap     <silent>         <space>ke   <Plug>(coc-refactor)
nmap     <silent>         <space>ka   <Cmd>CocList actions<CR>
nmap     <silent>         <space>kd   <Cmd>CocList diagnostics<CR>
nmap     <silent>         <space>kl   <Cmd>CocList<CR>
nmap     <silent>         <space>kf   <Plug>(coc-format)
nmap     <silent>         <space>ki   <Plug>(coc-diagnostic-info)
nmap     <silent>         <space>ko   <Cmd>CocList outline<CR>
nmap     <silent>         <space>l    <Plug>(coc-diagnostic-next)
nmap     <silent>         <space>L    <Plug>(coc-diagnostic-prev)
vmap     <silent>         <space>ka   <Plug>(coc-codeaction-selected)
vmap     <silent>         <space>kf   <Plug>(coc-format-selected)

# }}}
# fzf.vim {{{
const fzf_defaults = [
  '--ansi --bind="ctrl-/:toggle-preview,alt-i:toggle-all,ctrl-n:preview-page-down,ctrl-p:preview-page-up,ctrl-l:accept,' ..
  'ctrl-r:clear-screen,alt-k:next-history,alt-j:previous-history,ctrl-alt-j:page-down,ctrl-alt-k:page-up"',
  '--color=hl:#f158a6,fg+:#b8af96,hl+:#f158a6,bg+:#3b312b,border:#40362f,gutter:#21261d,pointer:#d3c94b,prompt:#c57c41,marker:#d24b98,info:#70a17c',
  '--pointer=● --marker=▶ --layout=reverse --tabstop=2 --info=inline --margin=1,3 --exact --header='
]
$FZF_DEFAULT_OPTS = join(fzf_defaults, " ")
g:fzf_command_prefix = 'Fzf'
g:fzf_history_dir = '~/.cache/vim/fzf_history'
g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9, 'border': 'none' } }

nnoremap <silent> <space>ff   <Cmd>FzfFiles!<CR>
nnoremap <silent> <space>fh   <Cmd>FzfHelptags!<CR>
nnoremap <silent> <space>fm   <Cmd>FzfMaps!<CR>
nnoremap <silent> <space>;    <Cmd>FzfBuffers!<CR>
nnoremap <silent> <space>ss   <Cmd>FzfRg!<CR>
nnoremap <silent> <space>sb   <Cmd>FzfBLines!<CR>
nnoremap <silent> <space>sw   :<C-u>FzfRg! <C-r><C-w><CR>
nnoremap <silent> <space>gc   <Cmd>FzfCommits!<CR>
nnoremap <silent> <space>gC   <Cmd>FzfBCommits!<CR>


# }}}
# fzf-hoogle.vim {{{
# augroup HoogleMaps
#   autocmd!
#   autocmd FileType haskell nnoremap <buffer>   <space>hh :Hoogle <C-r><C-w><CR>
# augroup END
# g:hoogle_fzf_header = ''
# g:hoogle_fzf_preview = 'down:50%:wrap'
# g:hoogle_count = 100
# g:hoogle_fzf_window = { 'right': '40%' }
# }}}
# undotree {{{
g:undotree_SetFocusWhenToggle = 1
g:undotree_WindowLayout       = 2
g:undotree_ShortIndicators    = 1
g:undotree_HelpLine           = 0
nmap    <silent>    4    <Cmd>UndotreeToggle<CR>
# }}}
# vim-easy-align {{{
vmap    <Enter>    <Plug>(EasyAlign)
# }}}
# vim-fugitive {{{
nnoremap    <space>gg    <Cmd>Git<CR>
nnoremap    <space>gb    <Cmd>Git blame<CR>
nnoremap    <space>gd    <Cmd>Git diff<CR>
nnoremap    <space>ge    <Cmd>Git edit<CR>
# }}}
# gh {{{
# nnoremap <space>gl <Cmd>split gh://monkoose/gists<CR>
# nnoremap <space>gp :split gh://gists/new/
# }}}
# fern {{{
g:fern#drawer_width = 35
nnoremap 1 <Cmd>Fern . -drawer -toggle<CR>
# }}}
# vim-gitgutter {{{
g:gitgutter_sign_modified_removed  = '≃'

nmap  <silent>   <space>gi <Plug>(GitGutterPreviewHunk)
nmap  <silent>   <space>guu <Plug>(GitGutterUndoHunk)
nmap  <silent>   <space>gss <Plug>(GitGutterStageHunk)

augroup GitGutterUpdate
  autocmd!
  autocmd BufWritePost * GitGutter
augroup END
# }}}
# vim9-stargate {{{
noremap <space><space> <Cmd>call stargate#OKvim(1)<CR>
nnoremap <space>w <Cmd>call stargate#Galaxy()<CR>

g:stargate_keymaps = {
  "~": "Ё",
  "Q": "Й", "W": "Ц", "E": "У", "R": "К", "T": "Е", "Y": "Н", "U": "Г", "I": "Ш", "O": "Щ", "P": "З", "{": "Х", "}": "Ъ",
   "A": "Ф", "S": "Ы", "D": "В", "F": "А", "G": "П", "H": "Р", "J": "О", "K": "Л", "L": "Д", ":": "Ж", '"': "Э",
    "Z": "Я", "X": "Ч", "C": "С", "V": "М", "B": "И", "N": "Т", "M": "Ь", "<": "Б", ">": "Ю",
  "`": "ё",
  "q": "й", "w": "ц", "e": "у", "r": "к", "t": "е", "y": "н", "u": "г", "i": "ш", "o": "щ", "p": "з", "[": "х", "]": "ъ",
   "a": "ф", "s": "ы", "d": "в", "f": "а", "g": "п", "h": "р", "j": "о", "k": "л", "l": "д", ";": "ж", "'": "э",
    "z": "я", "x": "ч", "c": "с", "v": "м", "b": "и", "n": "т", "m": "ь", ",": "б", ".": "ю"
}
# }}}
# termdebug {{{
# packadd termdebug
# g:termdebug_wide = 1
# g:termdebug_disasm_window = 15
# }}}

defcompile
# vim: foldmethod=marker
