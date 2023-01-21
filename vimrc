vim9script noclear

const config_dir = fnamemodify($MYVIMRC, ':h') .. '/config'

def Source(file: string)
    exe $'source {config_dir}/{file}'
enddef

Source('options.vim')
Source('plugins.vim')
Source('statusline.vim')

augroup StartupSetup
    autocmd!
    autocmd VimEnter * ++once Source('maps.vim')
augroup END
