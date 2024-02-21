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
    catch /^Vim:E662:/
      echohl ErrorMsg
      echom 'E662: At start of changelist'
      echohl None
    endtry
  endif
enddef
