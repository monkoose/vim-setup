vim9script noclear

export def Toggle(char: string)
  const lnum = line('.')
  const line = getline(lnum)
  const last_index = strchars(line) - 1
  const last_char = strgetchar(line, last_index)
  if last_char == char2nr(char)
    setline(lnum, strcharpart(line, 0, last_index))
  else
    setline(lnum, line .. char)
  endif
enddef
