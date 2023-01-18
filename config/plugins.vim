vim9script

plug#begin('~/.vim/plugged')

plug#('monkoose/boa-vim.vim')
plug#('tpope/vim-repeat')
plug#('tpope/vim-surround')
plug#('tpope/vim-characterize')
plug#('tpope/vim-commentary')
plug#('hail2u/vim-css3-syntax')
plug#('othree/html5.vim')
plug#('pangloss/vim-javascript')
plug#('honza/vim-snippets')
plug#('lacygoill/vim9asm')
plug#('thinca/vim-themis')
# plug#('monkoose/paredit')

# plug#('prabirshrestha/vim-lsp')  #{{{1
# plug#('rhysd/vim-lsp-ale')
# var serve_d: dict<any>
# def SetupServed()
#   if executable('serve-d')
#     serve_d = {
#       name: 'serve-d',
#       cmd: ['serve-d'],
#       allowlist: ['d'],
#     }
#   endif
# enddef
# autocmd User lsp_setup lsp#register_server({
#       \ name: 'serve-d',
#       \ cmd: ['/home/monkoose/Downloads/serve-d'],
#       \ allowlist: ['d'],
#       \ root_uri: (server_info) => lsp#utils#path_to_uri(
#       \   lsp#utils#find_nearest_parent_file_directory(
#       \     lsp#utils#get_buffer_path(),
#       \     ['dub.sdl', 'dub.json']
#       \   )
#       \ )
#       \ })
# plug#('prabirshrestha/asyncomplete.vim')
# plug#('prabirshrestha/asyncomplete-lsp.vim')
# plug#('prabirshrestha/asyncomplete-file.vim')
# plug#('prabirshrestha/asyncomplete-buffer.vim')
# g:asyncomplete_popup_delay = 50
# g:asyncomplete_auto_completeopt = 0
# # g:asyncomplete_auto_popup = 0
# g:asyncomplete_matchfuzzy = 0
# def AsyncompleteRegister()
#   asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
#     name: 'file',
#     allowlist: ['*'],
#     priority: 10,
#     completor: function('asyncomplete#sources#file#completor')
#   }))
#   asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
#     name: 'buffer',
#     allowlist: ['*'],
#     blocklist: ['go'],
#     completor: function('asyncomplete#sources#buffer#completor'),
#     config: {
#       max_buffer_size: 5000000,
#     },
#   }))
# enddef
# au User asyncomplete_setup AsyncompleteRegister()

plug#('dense-analysis/ale')  #{{{1
g:ale_completion_enabled = 0
g:ale_floating_preview = 1
g:ale_echo_cursor = 0
g:ale_hover_cursor = 0
g:ale_echo_msg_format = '[%linter%] %code: %%s'
g:ale_pattern_options_enabled = 0
g:ale_sign_error = 'E'
g:ale_sign_warning = 'W'
g:ale_sign_info = 'I'
g:ale_shell = '/bin/bash'
g:ale_virtualtext_cursor = 'current'
g:ale_virtualtext_delay = 100
g:ale_virtualtext_prefix = '   [%linter%] '
g:ale_warn_about_trailing_whitespace = 0
g:ale_completion_max_suggestions = 30
g:ale_floating_preview_popup_opts = {
  close: 'none',
  highlight: 'Normal',
  borderhighlight: ['PopupBorder'],
  borderchars: ['━', '┃', '━', '┃', '┏', '┓', '┛', '┗'],
}

g:ale_linters = {
  vim: [],
  d: ['dub'],
}

nmap  <space>kd  3
nnoremap  <space>ki  <Cmd>ALEDetail<CR>
nnoremap  <space>l   <Cmd>ALENextWrap<CR>
nnoremap  <space><C-l>   <Cmd>ALEPreviousWrap<CR>
nnoremap  <C-@><C-l>   <Cmd>ALEPreviousWrap<CR>

plug#('neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'})  #{{{1

g:coc_global_extensions = [
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

g:coc_snippet_next = '<C-i>'
# workaround to make '<M-i>' work
exe "set <M-i>=\ei"
g:coc_snippet_prev = '<M-i>'
inoremap <silent><expr>  <M-i>  coc#jumpable() ? "\<M-i" : ""
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
nnoremap  <space>kl  <Cmd>CocList<CR>
nnoremap  <space>kf  <Plug>(coc-format)
nnoremap  <space>ko  <Cmd>CocList outline<CR>
nnoremap <expr> K g:CocHasProvider('hover') ? g:CocActionAsync('doHover') : "K"
nnoremap <expr> <space>d
      \ g:CocHasProvider('definition') ? g:CocActionAsync('jumpDefinition') : "\<C-]>"
vnoremap  <space>ka  <Plug>(coc-codeaction-selected)
vnoremap  <space>kf  <Plug>(coc-format-selected)

plug#('junegunn/fzf.vim')  #{{{1

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
  # '--exact',
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

plug#('mbbill/undotree', {'on': 'UndotreeToggle'})  #{{{1

g:undotree_SetFocusWhenToggle = 1
g:undotree_WindowLayout       = 2
g:undotree_ShortIndicators    = 1
g:undotree_HelpLine           = 0
nmap    <silent>    4    <Cmd>UndotreeToggle<CR>

plug#('junegunn/vim-easy-align', {'on': '<Plug>(EasyAlign)'})  #{{{1

vmap    <Enter>    <Plug>(EasyAlign)

plug#('tpope/vim-fugitive')  #{{{1

nnoremap    <space>gg    <Cmd>Git<CR>
nnoremap    <space>gb    <Cmd>Git blame<CR>
nnoremap    <space>gd    <Cmd>Git diff<CR>
nnoremap    <space>ge    <Cmd>Gedit<CR>

plug#('lambdalisue/fern.vim')  #{{{1
plug#('lambdalisue/fern-hijack.vim')

g:fern#drawer_width = 35
nnoremap 1 <Cmd>Fern . -drawer -toggle<CR>

plug#('airblade/vim-gitgutter')  #{{{1

g:gitgutter_sign_modified_removed  = '≃'

nmap  <silent>   <space>gi <Plug>(GitGutterPreviewHunk)
nmap  <silent>   <space>guu <Plug>(GitGutterUndoHunk)
nmap  <silent>   <space>gss <Plug>(GitGutterStageHunk)

augroup GitGutterUpdate
  autocmd!
  autocmd BufWritePost * GitGutter
augroup END

plug#('monkoose/vim9-stargate')  #{{{1

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

# plug#('vlime/vlime')  #{{{1

# g:vlime_leader = ","
# g:vlime_contribs = ["SWANK-ASDF", "SWANK-TRACE-DIALOG", "SWANK-PACKAGE-FU", "SWANK-PRESENTATIONS", "SWANK-FANCY-INSPECTOR", "SWANK-C-P-C", "SWANK-ARGLISTS", "SWANK-REPL", "SWANK-FUZZY"]

plug#('lacygoill/vim9-syntax')  #{{{1

g:vim9_syntax = {
  errors: {
    event_wrong_case: false,
    octal_missing_o_prefix: false,
    range_missing_space: false,
    range_missing_specifier: false,
    strict_whitespace: true }}

# plug#('skanehira/gh.vim')  #{{{1
#
# nnoremap <space>gl <Cmd>split gh://monkoose/gists<CR>
# nnoremap <space>gp :split gh://gists/new/

# packadd termdebug  #{{{1
# g:termdebug_wide = 1
# g:termdebug_disasm_window = 15
# #}}}1

plug#end()


# vim: foldmethod=marker
