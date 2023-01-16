vim9script

['plugins', 'options', 'statusline', 'maps']
  ->map((_, val) => execute('source ~/.vim/config/' .. val .. '.vim'))
