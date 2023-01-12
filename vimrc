vim9script

['vimplug', 'options', 'plugins', 'statusline', 'maps']
  ->map((_, val) => execute('source ~/.vim/config/' .. val .. '.vim'))
