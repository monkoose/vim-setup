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
    :redraw
    const times_str = nr == 1 ? 'time' : 'times'
    :echohl Type
    :echomsg ' ' string(result * 1000)
    :echohl None
    :echon ' ms spent to run '
    :echohl String
    :echon cmd
    :echohl None
    :echon ' ' times ' ' times_str
  endtry
enddef

# Show syntax names
export def Synnames()
  echo ' ' .. synstack(line('.'), col('.'))
                  ->mapnew((_, v) => synIDattr(v, 'name'))
                  ->reverse()
                  ->join(' ')
enddef

export def Open_path()
  const path = expand('<cfile>')
  job_start(['xdg-open', path])
  :echohl String
  :echo 'Open '
  :echohl Identifier
  :echon path
  :echohl None
enddef

export def Toggle_loclist_window()
  if getwininfo(win_getid())[0].loclist
    :execute ':' .. winnr('#') .. 'wincmd w'
    :lclose
  else
    try
      :lopen
    catch /E776/
        :echohl WarningMsg
        :echo 'Location List is empty'
        :echohl None
    endtry
  endif
enddef

export def Toggle_qf_window()
  for win in getwininfo()
    if win.quickfix && !win.loclist
      if win.winid == win_getid()
        :execute ':' .. winnr('#') .. 'wincmd w'
      endif
      :cclose
      return
    endif
  endfor
  :botright copen
enddef

defcompile
