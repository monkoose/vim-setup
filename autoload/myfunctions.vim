vim9script

# simple calculation of the time wasted to execute command
export def Time(arg: string)
  var times: string
  var cmd: any
  [times; cmd] = split(arg)
  cmd = trim(join(cmd))
  const nr = str2nr(times)
  var cmds = repeat([cmd], nr)
  const time = reltime()

  try
      execute(cmds, '')
  finally
    const result = reltimefloat(reltime(time))
    redraw
    const times_str = nr == 1 ? 'time' : 'times'
    echohl Type
    echomsg '' string(result * 1000)
    echohl None
    echon ' ms spent to run '
    echohl String
    echon cmd
    echohl None
    echon '' times '' times_str
  endtry
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
