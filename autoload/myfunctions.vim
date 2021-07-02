vim9script

if empty(prop_type_get('yank_prop'))
  prop_type_add('yank_prop', { highlight: "HighlightedyankRegion", combine: true, priority: 100})
endif

def myfunctions#highlight_on_yank(timeout: number)
  if v:event.operator == 'y' && !(empty(v:event.regtype))
    const pos1 = getcharpos("'[")
    const pos2 = getcharpos("']")
    const start = [pos1[1], pos1[2] + pos1[3]]
    const end = [pos2[1], pos2[2] + pos2[3]]
    prop_add(start[0], start[1], { end_lnum: end[0], end_col: end[1] + 1, type: 'yank_prop' })
    timer_start(timeout, (_) => prop_remove({ type: 'yank_prop' }, start[0], end[0]))
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

def PreviewWindowNr(): number
  for nr in range(1, winnr('$'))
    if getwinvar(nr, '&pvw')
      return nr
    endif
  endfor
  return 0
enddef

def PopupWindowIDAtCursor(): number
  const cursor_pos = screenpos(win_getid(), line('.'), col('.'))
  var popup_window = popup_locate(cursor_pos.row + 1, cursor_pos.col)
  if !popup_window
    popup_window = popup_locate(cursor_pos.row - 1, cursor_pos.col)
  endif
  return popup_window
enddef

def myfunctions#close_popup_atcursor()
  const popup_winid = PopupWindowIDAtCursor()
  if !!popup_winid
    popup_close(popup_winid)
  else
    # just Esc press
    :execute "normal! \<Esc>"
  endif
enddef

def ScrollInPopup(winid: number, step: number)
  const popup_info = popup_getpos(winid)
  if !popup_info.scrollbar
    return
  endif
  const firstline = popup_getoptions(winid).firstline
  echom [firstline, popup_info.height, popup_info.lastline]
  if step < 0 && firstline <= abs(step)
    popup_setoptions(winid, {'firstline': 1})
  elseif step > 0 && firstline + step > popup_info.lastline
    return
  else
    popup_setoptions(winid, {'firstline': firstline + step})
  endif
enddef

def ExecuteCmdPvwOrCurrWin(cmd: string, curr_cmd: string)
  const pvw_nr = PreviewWindowNr()
  const curr_nr = winnr()
  if !!pvw_nr
    try
      :execute ':' .. pvw_nr .. 'wincmd w'
      :execute cmd
    finally
      :execute ':' .. curr_nr .. 'wincmd w'
    endtry
  else
    :execute curr_cmd
  endif
enddef

def myfunctions#scrolldown_or_next_hunk()
  const popup_winid = PopupWindowIDAtCursor()
  if !!popup_winid
    ScrollInPopup(popup_winid, 5)
  else
    ExecuteCmdPvwOrCurrWin("normal! 3\<C-e>", "normal ]c")
  endif
enddef

def myfunctions#scrollup_or_prev_hunk()
  const popup_winid = PopupWindowIDAtCursor()
  if !!popup_winid
    ScrollInPopup(popup_winid, -5)
  else
    ExecuteCmdPvwOrCurrWin("normal! 3\<C-y>", "normal [c")
  endif
enddef

defcompile
