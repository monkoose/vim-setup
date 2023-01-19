vim9script noclear

export def Toggle(char: string)
  const line = getline('.')
  const len = strchars(line)
  const last_index = len - 1
  const last_char = strgetchar(line, last_index)
  if last_char == char2nr(char)
    setline('.', strcharpart(line, 0, last_index))
  else
    setline('.', line .. char)
  endif
enddef
