vim9script

export def Jump()
  if v:count > 1
    feedkeys(v:count .. 'g;', 'nx')
  else
    const lnum = line('.')
    try
      feedkeys('g;', 'nx')
      while line('.') == lnum
        feedkeys('g;', 'nx')
      endwhile
    catch /^Vim:E66[234]:/
      echohl ErrorMsg
      echom v:errmsg
      echohl None
    endtry
  endif
enddef
