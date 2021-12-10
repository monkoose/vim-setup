vim9script

# simple calculation of the time wasted to execute command
def myfunctions#time(arg: string)
  var times: string
  var cmd: any
  [times; cmd] = split(arg)
  cmd = join(cmd)
  const nr = str2nr(times)
  const time = reltime()
  try
    for i in range(nr)
      :execute cmd
    endfor
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
def myfunctions#synnames()
  echo ' ' .. synstack(line('.'), col('.'))
                  ->mapnew((_, v) => synIDattr(v, 'name'))
                  ->reverse()
                  ->join(' ')
enddef

def myfunctions#open_path()
  const path = expand('<cfile>')
  job_start(['xdg-open', path])
  :echohl String
  :echo 'Open '
  :echohl Identifier
  :echon path
  :echohl None
enddef

def myfunctions#toggle_loclist_window()
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

def myfunctions#toggle_qf_window()
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
