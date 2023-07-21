vim9script

import autoload '../autoload/custom/minpac.vim'
import autoload '../autoload/myfunctions.vim' as mf

#################### STARTUP PLUGINS ####################
minpac.Add('tpope/vim-repeat')
minpac.Add('tpope/vim-characterize')
minpac.Add('tpope/vim-commentary')
minpac.Add('lambdalisue/vim-manpager')

# minpac.Add('hail2u/vim-css3-syntax')
# minpac.Add('othree/html5.vim')
# minpac.Add('pangloss/vim-javascript')

# minpac.Add('lacygoill/vim9asm')
# minpac.Add('thinca/vim-themis')
# minpac.Add('tweekmonster/helpful.vim')

# # yats.vim {{{1
# minpac.Add('HerringtonDarkholme/yats.vim', { Config: () => {
#   g:yats_host_keyword = 0
#   packadd! yats.vim
# }})

# # vim-svelte {{{1
# minpac.Add('evanleck/vim-svelte', { Config: () => {
#   g:svelte_preprocessor_tags = [
#     { name: 'ts', tag: 'script', as: 'typescript' }
#   ]
#   g:svelte_preprocessors = ['typescript', 'ts']
#   packadd! vim-svelte
# }})

# undotree {{{1
minpac.Add('mbbill/undotree', { Config: () => {
  g:undotree_SetFocusWhenToggle = 1
  g:undotree_WindowLayout       = 2
  g:undotree_ShortIndicators    = 1
  g:undotree_HelpLine           = 0

  packadd! undotree
  nnoremap <silent>  <A-4>  <Cmd>UndotreeToggle<CR>
}})

# vim9-stargate {{{1
minpac.Add('monkoose/vim9-stargate', { Config: () => {
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

# vim9-syntax {{{1
minpac.Add('lacygoill/vim9-syntax', { Config: () => {
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
# coc.nvim {{{1
def ExpandSnippet(): string
  if coc#expandable()
    return "\<C-R>=coc#rpc#request('doKeymap', ['snippets-expand', ''])\<CR>"
  endif
  echo " No such snippet."
  return ""
enddef

def CocConfirm(): string
  if coc#pum#visible()
    if coc#pum#info().index == -1
      return ExpandSnippet()
    endif
      return coc#pum#confirm()
  endif

  if pumvisible()
    if complete_info(["selected"]).selected == -1
      return ExpandSnippet()
    endif
    return "\<C-y>"
  endif

  return ExpandSnippet()
enddef

minpac.Add('honza/vim-snippets')
minpac.Add('neoclide/coc.nvim', {
  delay: 20,
  do: (_, name) => minpac.Do(name, ['yarn', 'install', '--frozen-lockfile']),
  Config: () => {
    g:coc_global_extensions =<< trim END
      coc-json
      coc-sh
      coc-snippets
      coc-pyright
      coc-tsserver
      coc-html
      coc-css
      coc-clangd
      coc-lua
      coc-fish
      coc-go
    END

    g:coc_borderchars = ['━', '┃', '━', '┃', '┏', '┓', '┛', '┗']
    g:coc_border_joinchars = ['┳', '┫', '┻', '┣']

    g:coc_snippet_next = '<C-i>'
    g:coc_snippet_prev = '<A-i>'

    packadd coc.nvim

    inoremap <silent><expr>  <A-i>  coc#jumpable() ? "\<A-i>" : ""
    inoremap  <C-n>  <Cmd>call coc#float#scroll(1, 4)<CR>
    inoremap  <C-p>  <Cmd>call coc#float#scroll(0, 4)<CR>
    inoremap <silent><expr>  <C-l>  CocConfirm()
    inoremap <silent><expr>  <C-j>  coc#pum#visible() ? coc#pum#next(1) : pumvisible() ? "\<C-n>" : coc#refresh()
    inoremap <silent><expr>  <C-k>  coc#pum#visible() ? coc#pum#prev(1) : pumvisible() ? "\<C-p>" : coc#refresh()
    inoremap <silent><expr>  <C-e> coc#pum#visible() ? coc#pum#cancel() : "\<C-e>"
    inoremap <silent> <CR>  <C-g>u<CR><C-r>=coc#on_enter()<CR>
    inoremap  <A-s>  <Cmd>call CocActionAsync('showSignatureHelp')<CR>
    nnoremap  <space>kk  <Cmd>CocRestart<CR>
    nnoremap  <space>D   <Plug>(coc-declaration)
    nnoremap  <space>kt   <Plug>(coc-type-definition)
    nnoremap  <space>kd  <Cmd>CocList diagnostics<CR>
    nnoremap  <space>kD  <Cmd>call CocAction('diagnosticToggleBuffer')<CR>
    nnoremap  <space>ki  <Plug>(coc-diagnostic-info)
    nnoremap  <space>l   <Cmd>call CocActionAsync('diagnosticNext') \| normal lh<CR>
    nnoremap  <space><C-l>   <Cmd>call CocActionAsync('diagnosticPrevious')<CR>
    nnoremap  <C-@><C-l>   <Cmd>call CocActionAsync('diagnosticPrevious')<CR>
    nnoremap  <space>kr  <Plug>(coc-references)
    nnoremap  <space>kR  <Plug>(coc-rename)
    nnoremap  <space>ke  <Plug>(coc-refactor)
    nnoremap <silent>  <space>kA  <Plug>(coc-codeaction)
    nnoremap <silent>  <space>ka  <Plug>(coc-codeaction-line)
    nnoremap  <space>kl  <Cmd>CocList<CR>
    nnoremap  <space>ko  <Cmd>CocList outline<CR>
    nnoremap  <space>ks  <Cmd>CocList symbols<CR>
    nnoremap  <space>kc  <Plug>(coc-codelens-action)
    nmap <expr> K g:CocHasProvider('hover') ? g:CocActionAsync('doHover') : "K"
    nmap <expr> <space>d
          \ g:CocHasProvider('definition') ? g:CocActionAsync('jumpDefinition') : "\<C-]>"
    xnoremap  <space>ka  <Plug>(coc-codeaction-selected)
    nnoremap  <space>kf  <Plug>(coc-format)
    xnoremap  <space>kf  <Plug>(coc-format-selected)
    nnoremap  <space>kF  <Plug>(coc-format-selected)

    xnoremap if <Plug>(coc-funcobj-i)
    onoremap if <Plug>(coc-funcobj-i)
    xnoremap af <Plug>(coc-funcobj-a)
    onoremap af <Plug>(coc-funcobj-a)
    xnoremap ic <Plug>(coc-classobj-i)
    onoremap ic <Plug>(coc-classobj-i)
    xnoremap ac <Plug>(coc-classobj-a)
    onoremap ac <Plug>(coc-classobj-a)
  }
})

# fzf.vim {{{1
minpac.Add('junegunn/fzf.vim', { delay: 10, Config: () => {
  g:fzf_command_prefix = 'Fzf'

  # 'label:71',
  const fzf_colors =<< trim END
    fg:-1
    bg:-1
    hl:205
    fg+:248
    hl+:205
    bg+:235
    border:71
    preview-fg:-1
    preview-bg:-1
    gutter:-1
    query:3
    spinner:160:italic
    prompt:4
    marker:32
    info:6
  END

  # '--exact',
  # '--info="inline:  * "',
  # '--border-label=hello',
  # '--border-label-pos=10',
  # '--preview-label=hello',
  const fzf_defaults =<< trim eval END
    --margin=0
    --scrollbar=▐
    --no-separator
    --header=
    --preview-window=down,50%,border-top
    --color=16,{join(fzf_colors, ',')}
  END

  setenv('FZF_DEFAULT_OPTS', getenv('FZF_DEFAULT_OPTS') .. ' ' .. join(fzf_defaults, " "))
  g:fzf_history_dir = '~/.cache/vim/fzf_history'
  g:fzf_layout = { window: {
    width: 0.9,
    height: 0.9,
    border: 'bold' }}

  packadd fzf.vim

  nnoremap <silent>  <space>ff  <Cmd>FzfFiles<CR>
  nnoremap <silent>  <space>fh  <Cmd>FzfHelptags<CR>
  nnoremap <silent>  <space>fm  <Cmd>FzfMaps<CR>
  nnoremap <silent>  <space>;   <Cmd>FzfBuffers<CR>
  nnoremap <silent>  <space>ss  <Cmd>FzfRg<CR>
  nnoremap <silent>  <space>sb  <Cmd>FzfBLines<CR>
  nnoremap <silent>  <space>sw  <Cmd>exe "FzfRg " .. expand('<cword>')<CR>
  nnoremap <silent>  <space>gc  <Cmd>FzfCommits<CR>
  nnoremap <silent>  <space>gC  <Cmd>FzfBCommits<CR>
}})

# wiki.vim {{{1
minpac.Add('lervag/wiki.vim', { delay: 30, Config: () => {
  g:wiki_root = '~/Documents/wiki'
  g:wiki_fzf_pages_opts = '--preview "bat --color=always {1}"'

  packadd wiki.vim
}})

# vim-dispatch {{{1
minpac.Add('tpope/vim-dispatch', { delay: 40, Config: () => {
  g:dispatch_handlers = ["job", "terminal"]

  packadd vim-dispatch
}})

# vim-go {{{1
minpac.Add('fatih/vim-go', { Config: () => {
  g:go_gopls_enabled = 0
  g:go_def_mapping_enabled = 0
  g:go_doc_keywordprg_enabled = 0
  g:go_term_enabled = 1
  g:go_fmt_autosave = 0
  g:go_imports_autosave = 0

  # highlights
  g:go_highlight_operators = 1
  g:go_highlight_functions = 1
  g:go_highlight_function_calls = 1
  g:go_highlight_types = 1
  g:go_highlight_fields = 1
  g:go_highlight_build_constraints = 1

  packadd! vim-go
}})

# vim-gutentags {{{1
minpac.Add('ludovicchabant/vim-gutentags', { Config: () => {
  g:gutentags_project_root = ['.git', 'vscripts']
  g:gutentags_add_default_project_roots = 0
  g:gutentags_file_list_command = 'fd --type=f'
  # g:gutentags_modules = ['cscope', 'ctags']
  # g:gutentags_cscope_build_inverted_index = 1
  com! GutentagsEnable :packadd vim-gutentags | gutentags#setup_gutentags() | delc GutentagsEnable
}})

# vim-easy-align {{{1
minpac.Add('junegunn/vim-easy-align', { delay: 50, Config: () => {
  packadd vim-easy-align
  vmap  <Enter>  <Plug>(EasyAlign)
}})

# vim-surround {{{1
minpac.Add('tpope/vim-surround', { delay: 30, Config: () => {
  packadd vim-surround
}})

# vim-eunuch {{{1
minpac.Add('tpope/vim-eunuch', { delay: 30, Config: () => {
  packadd vim-eunuch
  doautocmd eunuch VimEnter
}})

# vim-fugitive {{{1
minpac.Add('tpope/vim-rhubarb', {})
minpac.Add('tpope/vim-fugitive', {
  delay: 5,
  Config: () => {
    packadd vim-rhubarb
    packadd vim-fugitive
    # update statusline
    doautocmd User FugitiveChanged

    nnoremap    <space>gg    <Cmd>Git<CR>
    nnoremap    <space>gb    <Cmd>Git blame<CR>
    nnoremap    <space>gd    <Cmd>Git diff<CR>
    nnoremap    <space>ge    <Cmd>Gedit<CR>
  }
})

# vim-dadbod {{{1
minpac.Add('kristijanhusak/vim-dadbod-completion', {})
minpac.Add('kristijanhusak/vim-dadbod-ui', {})
minpac.Add('tpope/vim-dadbod', {
  delay: 50,
  Config: () => {
    packadd vim-dadbod
    packadd vim-dadbod-completion
    packadd vim-dadbod-ui
  }
})

# vim-gitgutter {{{1
minpac.Add('airblade/vim-gitgutter', { delay: 5, Config: () => {
  g:gitgutter_sign_modified_removed  = '≃'

  packadd vim-gitgutter
  doautocmd gitgutter VimEnter

  nmap  <silent>   <space>gi <Plug>(GitGutterPreviewHunk)
  nmap  <silent>   <space>guu <Plug>(GitGutterUndoHunk)
  nmap  <silent>   <space>gss <Plug>(GitGutterStageHunk)

  augroup GitGutterUpdate
    autocmd!
    autocmd BufWritePost * GitGutter
  augroup END
}})

# # indentLine {{{1
# minpac.Add('Yggdroot/indentLine', { Config: () => {
#   packadd! indentLine
# }})

# # gh.vim {{{1
# minpac.Add('skanehira/gh.vim')

# packadd! gh.vim
# nnoremap <space>gl <Cmd>split gh://monkoose/gists<CR>
# nnoremap <space>gp :split gh://gists/new/

# # termdebug {{{1
# packadd termdebug
# g:termdebug_wide = 1
# g:termdebug_disasm_window = 15
# # }}}1

# vim: foldmethod=marker
