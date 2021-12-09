call plug#begin('~/.vim/plugged')
Plug 'monkoose/boa-vim.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'hail2u/vim-css3-syntax'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'honza/vim-snippets'
Plug 'monkoose/vim9-stargate'
Plug 'fatih/vim-go'
Plug 'Vimjas/vim-python-pep8-indent', {'for': ['python']}
Plug 'cespare/vim-toml', {'for': ['toml']}
" Plug 'Shougo/context_filetype.vim'
" Plug 'thinca/vim-themis'
" Plug 'evanleck/vim-svelte', {'for': ['svelte']}

" PLUGINS WITH CUSTOM CONFIG
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'junegunn/vim-easy-align', {'on': '<Plug>(EasyAlign)'}
Plug 'tpope/vim-fugitive'
Plug 'skanehira/gh.vim'
Plug 'airblade/vim-gitgutter'
call plug#end()
