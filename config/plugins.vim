vim9script

import autoload '../autoload/custom/minpac.vim'
const MinpacAdd = minpac.Add

#################### STARTUP PLUGINS ####################
MinpacAdd('tpope/vim-repeat')
MinpacAdd('tpope/vim-characterize')
MinpacAdd('tpope/vim-commentary')
MinpacAdd('hail2u/vim-css3-syntax')
MinpacAdd('othree/html5.vim')
MinpacAdd('pangloss/vim-javascript')
MinpacAdd('honza/vim-snippets')
MinpacAdd('lacygoill/vim9asm')
MinpacAdd('thinca/vim-themis')

# mbbill/undotree {{{1
MinpacAdd('mbbill/undotree', { Config: () => {
  g:undotree_SetFocusWhenToggle = 1
  g:undotree_WindowLayout       = 2
  g:undotree_ShortIndicators    = 1
  g:undotree_HelpLine           = 0

  packadd! undotree
  exe "set <M-4>=\e4"
  nnoremap <silent>  <M-4>  <Cmd>UndotreeToggle<CR>
}})

# monkoose/vim9-stargate {{{1
MinpacAdd('monkoose/vim9-stargate', { Config: () => {
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
      "z": "я", "x": "ч", "c": "с", "v": "м", "b": "и", "n": "т", "m": "ь", ",": "б", ".": "ю" }

  packadd! vim9-stargate
}})

# lacygoill/vim9-syntax {{{1
MinpacAdd('lacygoill/vim9-syntax', { Config: () => {
  g:vim9_syntax = {
    errors: {
      event_wrong_case: false,
      octal_missing_o_prefix: false,
      range_missing_space: false,
      range_missing_specifier: false,
      strict_whitespace: true }}

  packadd! vim9-syntax
}}) #}}}

#################### DEFERED PLUGINS ####################
# dense-analysis/ale {{{1
MinpacAdd('dense-analysis/ale', { delay: 20, Config: () => {
  g:ale_completion_enabled = 0
  g:ale_history_enabled = 0
  g:ale_set_highlights = 0
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
    borderchars: ['━', '┃', '━', '┃', '┏', '┓', '┛', '┗'], }

  g:ale_linters = {
    vim: [],
    d: ['dub'], }

  packadd ale

  nmap  <space>kd  3
  nnoremap  <space>ki     <Cmd>ALEDetail<CR>
  nnoremap  <space>l      <Cmd>ALENextWrap<CR>
  nnoremap  <space><C-l>  <Cmd>ALEPreviousWrap<CR>
  nnoremap  <C-@><C-l>    <Cmd>ALEPreviousWrap<CR>
}})

# neoclide/coc.nvim {{{1
MinpacAdd('neoclide/coc.nvim', {
  do: (_, _) => system('yarn install --frozen-lockfile'),
  delay: 20,
  Config: () => {
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
      'coc-dlang',
    ]

    packadd coc.nvim

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
    exe "set <M-s>=\es"
    inoremap  <M-s>  <Cmd>call CocActionAsync('showSignatureHelp')<CR>
    nnoremap  <space>kk  <Cmd>CocRestart<CR>
    nnoremap  <space>D   <Plug>(coc-declaration)
    nnoremap  <space>kr  <Plug>(coc-references)
    nnoremap  <space>kR  <Plug>(coc-rename)
    nnoremap  <space>ke  <Plug>(coc-refactor)
    nnoremap  <space>ka  <Cmd>CocList actions<CR>
    nnoremap  <space>kl  <Cmd>CocList<CR>
    nnoremap  <space>kf  <Plug>(coc-format)
    nnoremap  <space>ko  <Cmd>CocList outline<CR>
    nmap <expr> K g:CocHasProvider('hover') ? g:CocActionAsync('doHover') : "K"
    nmap <expr> <space>d
          \ g:CocHasProvider('definition') ? g:CocActionAsync('jumpDefinition') : "\<C-]>"
    vnoremap  <space>ka  <Plug>(coc-codeaction-selected)
    vnoremap  <space>kf  <Plug>(coc-format-selected)
  }
})

# junegunn/fzf.vim {{{1
g:loaded_fzf = 1
MinpacAdd('junegunn/fzf.vim', { delay: 10, Config: () => {
  g:fzf_command_prefix = 'Fzf'

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
    '--margin=0',
    # '--exact',
    '--scrollbar=▐',
    '--no-separator',
    '--header=',
    '--preview-window=down,50%,border-top',
    '--color=16,' .. join(fzf_colors, ','),
  ]

  setenv('FZF_DEFAULT_OPTS', getenv('FZF_DEFAULT_OPTS') .. ' ' .. join(fzf_defaults, " "))
  g:fzf_history_dir = '~/.cache/vim/fzf_history'
  g:fzf_layout = { window: {
    width: 0.9,
    height: 0.9,
    border: 'sharp' }}

  unlet! g:loaded_fzf
  exe $'source {$VIM}/vimfiles/plugin/fzf.vim'
  packadd fzf.vim

  nnoremap <silent>  <space>ff  <Cmd>FzfFiles<CR>
  nnoremap <silent>  <space>fh  <Cmd>FzfHelptags<CR>
  nnoremap <silent>  <space>fm  <Cmd>FzfMaps<CR>
  nnoremap <silent>  <space>;   <Cmd>FzfBuffers<CR>
  nnoremap <silent>  <space>ss  <Cmd>FzfRg<CR>
  nnoremap <silent>  <space>sb  <Cmd>FzfBLines<CR>
  nnoremap <silent>  <space>sw  :<C-u>FzfRg <C-r><C-w><CR>
  nnoremap <silent>  <space>gc  <Cmd>FzfCommits<CR>
  nnoremap <silent>  <space>gC  <Cmd>FzfBCommits<CR>
}})

# junegunn/vim-easy-align {{{1
MinpacAdd('junegunn/vim-easy-align', { delay: 50, Config: () => {
  packadd vim-easy-aling
  vmap  <Enter>  <Plug>(EasyAlign)
}})

# tpope/vim-surround {{{1
MinpacAdd('tpope/vim-surround', { delay: 30, Config: () => {
  packadd vim-surround
}})

# tpope/vim-fugitive {{{1
MinpacAdd('tpope/vim-fugitive', {
  dependencies: ['tpope/vim-rhubarb'],
  delay: 5,
  Config: () => {
    packadd vim-fugitive
    packadd vim-rhubarb
    # update statusline
    doautocmd User FugitiveChanged

    nnoremap    <space>gg    <Cmd>Git<CR>
    nnoremap    <space>gb    <Cmd>Git blame<CR>
    nnoremap    <space>gd    <Cmd>Git diff<CR>
    nnoremap    <space>ge    <Cmd>Gedit<CR>
  }
})

# lambdalisue/fern.vim {{{1
MinpacAdd('lambdalisue/fern.vim', {
  dependencies: ['lambdalisue/fern-hijack.vim'],
  Config: () => {
    g:fern#drawer_width = 35

    packadd! fern.vim
    packadd! fern-hijack.vim

    exe "set <M-1>=\e1"
    nnoremap <M-1>  <Cmd>Fern . -drawer -toggle<CR>
  }
})

# airblade/vim-gitgutter {{{1
MinpacAdd('airblade/vim-gitgutter', { delay: 5, Config: () => {
  g:gitgutter_sign_modified_removed  = '≃'

  packadd vim-gitgutter

  nmap  <silent>   <space>gi <Plug>(GitGutterPreviewHunk)
  nmap  <silent>   <space>guu <Plug>(GitGutterUndoHunk)
  nmap  <silent>   <space>gss <Plug>(GitGutterStageHunk)

  augroup GitGutterUpdate
    autocmd!
    autocmd BufWritePost * GitGutter
  augroup END
}})

# # skanehira/gh.vim {{{1
# MinpacAdd('skanehira/gh.vim')

# packadd! gh.vim
# nnoremap <space>gl <Cmd>split gh://monkoose/gists<CR>
# nnoremap <space>gp :split gh://gists/new/

# # termdebug {{{1
# packadd termdebug
# g:termdebug_wide = 1
# g:termdebug_disasm_window = 15
# # }}}1

filetype plugin indent on
syntax on

# vim: foldmethod=marker
