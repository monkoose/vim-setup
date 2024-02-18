vim9script

export def Set(str: string)
  if exists('b:undo_ftplugin')
    b:undo_ftplugin ..= ' | ' .. str
  else
    b:undo_ftplugin = str
  endif
enddef
