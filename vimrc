vim9script

def LoadConfigFiles(files: list<string>)
  for file in files
    execute('source ~/.vim/config/' .. file .. '.vim')
  endfor
enddef

LoadConfigFiles([
  'vimplug',
  'options',
  'plugins',
  'statusline',
  'maps',
])
