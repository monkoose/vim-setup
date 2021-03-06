vim9script

# coc.nvim {{{
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
inoremap  n  <Cmd>call coc#float#scroll(1, 4)<CR>
inoremap  p  <Cmd>call coc#float#scroll(0, 4)<CR>
inoremap <expr>  <C-l>  pumvisible() ? coc#_select_confirm() : coc#refresh()
inoremap <expr>  <C-j>  pumvisible() ? "\<C-n>" : coc#refresh()
inoremap <expr>  <C-k>  pumvisible() ? "\<C-p>" : coc#refresh()
inoremap  <CR>  <C-g>u<CR><C-r>=coc#on_enter()<CR>
inoremap  s  <Cmd>call CocActionAsync('showSignatureHelp')<CR>
nnoremap  <space>kk  <Cmd>CocRestart<CR>
nnoremap  <space>D   <Plug>(coc-declaration)
nnoremap  <space>kr  <Plug>(coc-references)
nnoremap  <space>kR  <Plug>(coc-rename)
nnoremap  <space>ke  <Plug>(coc-refactor)
nnoremap  <space>ka  <Cmd>CocList actions<CR>
nnoremap  <space>kd  <Cmd>CocList diagnostics<CR>
nnoremap  <space>kl  <Cmd>CocList<CR>
nnoremap  <space>kf  <Plug>(coc-format)
nnoremap  <space>ki  <Plug>(coc-diagnostic-info)
nnoremap  <space>ko  <Cmd>CocList outline<CR>
nnoremap  <space>l   <Plug>(coc-diagnostic-next)
nnoremap  <space>L   <Plug>(coc-diagnostic-prev)
nnoremap <expr> K g:CocHasProvider('hover') ? g:CocActionAsync('doHover') : "K"
nnoremap <expr> <space>d
      \ g:CocHasProvider('definition') ? g:CocActionAsync('jumpDefinition') : "\<C-]>"
vnoremap  <space>ka  <Plug>(coc-codeaction-selected)
vnoremap  <space>kf  <Plug>(coc-format-selected)

# }}}
# fzf.vim {{{
const fzf_colors = [
  'hl:#f158a6',
  'fg+:#b8af96',
  'hl+:#f158a6',
  'bg+:#3b312b',
  'border:#40362f',
  'gutter:#21261d',
  'pointer:#d3c94b',
  'prompt:#c57c41',
  'marker:#d24b98',
  'info:#70a17c',
]

const fzf_defaults = [
  '--margin=1,3',
  '--exact',
  '--header=',
  '--preview-window=down,50%,border-top',
  '--color=' .. join(fzf_colors, ','),
]

setenv('FZF_DEFAULT_OPTS', getenv('FZF_DEFAULT_OPTS') .. ' ' .. join(fzf_defaults, " "))
g:fzf_command_prefix = 'Fzf'
g:fzf_history_dir = '~/.cache/vim/fzf_history'
g:fzf_layout = { window: { width: 0.9,
                           height: 0.9,
                           border: 'none' }}

nnoremap <silent> <space>ff   <Cmd>FzfFiles<CR>
nnoremap <silent> <space>fh   <Cmd>FzfHelptags<CR>
nnoremap <silent> <space>fm   <Cmd>FzfMaps<CR>
nnoremap <silent> <space>;    <Cmd>FzfBuffers<CR>
nnoremap <silent> <space>ss   <Cmd>FzfRg<CR>
nnoremap <silent> <space>sb   <Cmd>FzfBLines<CR>
nnoremap <silent> <space>sw   :<C-u>FzfRg <C-r><C-w><CR>
nnoremap <silent> <space>gc   <Cmd>FzfCommits<CR>
nnoremap <silent> <space>gC   <Cmd>FzfBCommits<CR>


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
nnoremap    <space>ge    <Cmd>Gedit<CR>
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
g:gitgutter_sign_modified_removed  = '???'

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
  "~": "??",
  "Q": "??", "W": "??", "E": "??", "R": "??", "T": "??", "Y": "??", "U": "??", "I": "??", "O": "??", "P": "??", "{": "??", "}": "??",
   "A": "??", "S": "??", "D": "??", "F": "??", "G": "??", "H": "??", "J": "??", "K": "??", "L": "??", ":": "??", '"': "??",
    "Z": "??", "X": "??", "C": "??", "V": "??", "B": "??", "N": "??", "M": "??", "<": "??", ">": "??",
  "`": "??",
  "q": "??", "w": "??", "e": "??", "r": "??", "t": "??", "y": "??", "u": "??", "i": "??", "o": "??", "p": "??", "[": "??", "]": "??",
   "a": "??", "s": "??", "d": "??", "f": "??", "g": "??", "h": "??", "j": "??", "k": "??", "l": "??", ";": "??", "'": "??",
    "z": "??", "x": "??", "c": "??", "v": "??", "b": "??", "n": "??", "m": "??", ",": "??", ".": "??"
}
# }}}
# termdebug {{{
# packadd termdebug
# g:termdebug_wide = 1
# g:termdebug_disasm_window = 15
# }}}

# vim: foldmethod=marker
