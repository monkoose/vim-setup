vim9script noclear

const config_dir = fnamemodify($MYVIMRC, ':h') .. '/config'

def Source(file: string)
  exe $'source {config_dir}/{file}'
enddef

Source('options.vim')
Source('plugins.vim')
filetype plugin indent on
Source('statusline.vim')
Source('maps.vim')
