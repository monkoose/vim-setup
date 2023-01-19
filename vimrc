vim9script noclear

['plugins', 'options', 'statusline', 'maps']
  ->map((_, val) => execute('source ~/.vim/config/' .. val .. '.vim'))
