vim9script

# simple calculation of the time wasted to execute command
export def Time(arg: string)
  const str = trim(arg)
  const times = matchstr(str, '^\d*')
  const times_len = strcharlen(times)
  const cmd = str->strcharpart(times_len)->trim()
  const nr = times_len > 0 ? str2nr(times) : 1
  var cmds = repeat([cmd], nr)
  const time = reltime()

  execute(cmds, '')

  const result = reltimefloat(reltime(time))
  redraw
  const times_str = nr == 1 ? 'time' : 'times'
  echohl Type
  echomsg ' ' string(result * 1000)
  echohl None
  echon ' ms spent to run '
  echohl String
  echon cmd
  echohl None
  echon ' ' nr ' ' times_str
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
  if win_gettype() ==? 'loclist'
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
