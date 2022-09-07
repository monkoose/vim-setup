vim9script

def TimeSpend(cmd_string: string): list<any>
  const str = trim(cmd_string)
  const times = matchstr(str, '^\d*')
  const times_len = strcharlen(times)
  const cmd = str->strcharpart(times_len)->trim()
  const nr = times_len > 0 ? str2nr(times) : 1
  const range = range(nr)
  const time = reltime()
  for _ in range
    execute cmd
  endfor
  const time_spend = reltimefloat(reltime(time))
  const time_per_cmd = time_spend / nr
  return [cmd, time_per_cmd]
enddef

# simple calculation of the time wasted to execute command
export def PrintTime(cmd_string: string)
  const [cmd, time_per_cmd] = TimeSpend(cmd_string)
  redraw
  echohl Type
  echomsg ' ' string(time_per_cmd * 1000)
  echohl None
  echon ' ms spent to run '
  echohl String
  echon cmd
  echohl None
enddef

# Show syntax names
export def Synnames()
  echo '' synstack(line('.'), col('.'))
            ->mapnew((_, v) => synIDattr(v, 'name'))
            ->reverse()
            ->join(' ')
enddef

export def OpenPath()
  const path = expand('<cfile>')
  job_start(['xdg-open', path])
  echohl String
  echo 'Open '
  echohl Identifier
  echon path
  echohl None
enddef

def JumpToPreviousWindow()
  execute ':' .. winnr('#') .. 'wincmd w'
enddef

export def ToggleLoclistWindow()
  if win_gettype() == 'loclist'
    JumpToPreviousWindow()
    lclose
  else
    try
      lopen
    catch /E776/
      echohl WarningMsg
      echo ' Location List is empty'
      echohl None
    endtry
  endif
enddef

export def ToggleQfWindow()
  for win in range(1, winnr('$'))
    if win_gettype(win) == 'quickfix'
      if win_getid(win) == win_getid()
        JumpToPreviousWindow()
      endif
      cclose
      return
    endif
  endfor
  botright copen
enddef
