unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

let s:config_dir = expand('<sfile>:p:h') .. '/'
execute 'source ' .. s:config_dir .. 'vimplug.vim'
execute 'source ' .. s:config_dir .. 'plugins_config.vim'
execute 'source ' .. s:config_dir .. 'options.vim'
execute 'source ' .. s:config_dir .. 'autocmds.vim'
execute 'source ' .. s:config_dir .. 'statusline.vim'
execute 'source ' .. s:config_dir .. 'maps.vim'
