vim9script noclear

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
  const [cmd: string, time_per_cmd: float] = TimeSpend(cmd_string)
  redraw
  echohl Type
  echomsg ' ' .. string(time_per_cmd * 1000.0)
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

export def OpenPath(path: string = expand('<cfile>'))
  job_start(['xdg-open', path], {
    exit_cb: (_, s) => {
      if s == 0
        echohl String | echon ' ' .. path
        echohl Function | echon ' has been opened' | echohl None
      else
        echohl WarningMsg | echo " Can't open "
        echohl String | echon path | echohl None
      endif
    }
  })
enddef

def JumpToPreviousWindow()
  exe ':' .. winnr('#') .. 'wincmd w'
enddef

export def ToggleLoclistWindow(cmd = '')
  if win_gettype() == 'loclist'
    const main_winid = getloclist(0, { filewinid: 0 }).filewinid
    if main_winid != 0
      exe ':' .. win_id2win(main_winid) .. 'wincmd w'
    endif
    lclose
  else
    const loc_winid = getloclist(0, { winid: 0 }).winid
    if loc_winid != 0
      lclose
    else
      try
        if !empty(cmd)
          exe cmd
        endif
        lopen
      catch /E776/
        echohl WarningMsg
        echo ' Location List is empty'
        echohl None
      endtry
    endif
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

defcompile
