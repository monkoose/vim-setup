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
