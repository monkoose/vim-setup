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
  'coc-clangd',
  'coc-lua',
  'coc-fish',
]

g:coc_snippet_next = '<C-s>'
g:coc_snippet_prev = 's'
inoremap <silent><expr>  <C-s>  coc#jumpable() ? "\<C-s>" : ""
inoremap  <C-n>  <Cmd>call coc#float#scroll(1, 4)<CR>
inoremap  <C-p>  <Cmd>call coc#float#scroll(0, 4)<CR>
inoremap <silent><expr>  <C-l>  coc#pum#visible() ? coc#pum#confirm() : pumvisible() ? "\<C-y>" : coc#refresh()
inoremap <silent><expr>  <C-j>  coc#pum#visible() ? coc#pum#next(1) : pumvisible() ? "\<C-n>" : coc#refresh()
inoremap <silent><expr>  <C-k>  coc#pum#visible() ? coc#pum#prev(1) : pumvisible() ? "\<C-p>" : coc#refresh()
inoremap <silent><expr>  <C-e> coc#pum#visible() ? coc#pum#cancel() : "\<C-e>"
inoremap <silent> <CR>  <C-g>u<CR><C-r>=coc#on_enter()<CR>
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
  'fg:-1',
  'bg:-1',
  'hl:205',
  'fg+:248',
  'hl+:205',
  'bg+:235',
  'border:71',
  'preview-fg:-1',
  'preview-bg:-1',
  'gutter:-1',
  'query:3',
  'spinner:160:italic',
  'prompt:4',
  'marker:32',
  'info:6',
  ]

const fzf_defaults = [
  '--margin=0,0',
  '--exact',
  '--header=',
  '--preview-window=down,50%,border-top',
  '--color=16,' .. join(fzf_colors, ','),
  ]

setenv('FZF_DEFAULT_OPTS', getenv('FZF_DEFAULT_OPTS') .. ' ' .. join(fzf_defaults, " "))
g:fzf_command_prefix = 'Fzf'
g:fzf_history_dir = '~/.cache/vim/fzf_history'
g:fzf_layout = { window: {
  width: 0.9,
  height: 0.9,
  border: 'sharp' }}

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
# # gh {{{
# nnoremap <space>gl <Cmd>split gh://monkoose/gists<CR>
# nnoremap <space>gp :split gh://gists/new/
# # }}}
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
# # termdebug {{{
# packadd termdebug
# g:termdebug_wide = 1
# g:termdebug_disasm_window = 15
# # }}}
# vlime {{{
g:vlime_leader = ","
# }}}
# vim9-syntax {{{

g:vim9_syntax = {
  errors: {
    event_wrong_case: false,
    octal_missing_o_prefix: false,
    range_missing_space: false,
    range_missing_specifier: false,
    strict_whitespace: true }}
# }}}

# vim: foldmethod=marker
