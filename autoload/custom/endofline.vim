vim9script

export def Toggle(char: string)
  var line = getline('.')
  const len = strchars(line)
  const lastchar = strgetchar(line, len - 1)
  if lastchar ==# char2nr(char)
    line = strcharpart(line, 0, len - 1)
  else
    line = line .. char
  endif
  setline('.', line)
enddef

defcompile
