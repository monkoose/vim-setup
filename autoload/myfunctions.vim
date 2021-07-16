vim9script

if empty(prop_type_get('yank_prop'))
  prop_type_add('yank_prop', { highlight: "HighlightedyankRegion", combine: true, priority: 100})
endif

def myfunctions#highlight_on_yank(timeout: number)
  if v:event.visual
    return
  endif

  if v:event.operator == 'y' && !(empty(v:event.regtype))
    const start = getpos("'[")
    const start_line = start[1]
    const start_col = start[2] + start[3]
    const end_line = getpos("']")[1]
    const shift = start_line == end_line ? start_col - 1 : 0
    const length = len(v:event.regcontents[-1]) + 1 + shift

    timer_start(1, (_) => prop_add(start_line,
                                   start_col,
                                   { end_lnum: end_line, end_col: length, type: 'yank_prop' }))
    timer_start(timeout, (_) => prop_remove({ type: 'yank_prop' }, start_line, end_line))
  endif
enddef

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

def myfunctions#toggle_semicolon()
  const view = winsaveview()
  if !search(';\_$', 'Wnc', view.lnum)
    :execute 'keepp s/\_$/;/'
  else
    :execute 'keepp s/;\_$//'
  endif
  winrestview(view)
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
