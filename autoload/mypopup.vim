vim9script

def PreviewWinId(): number
  for nr in range(1, winnr('$'))
    if win_gettype(nr) == 'preview'
      return win_getid(nr)
    endif
  endfor
  return 0
enddef

def PopupWindowIdAtCursor(): number
  const cursor_pos = screenpos(win_getid(), line('.'), col('.'))
  var popup_window = popup_locate(cursor_pos.row + 1, cursor_pos.col)
  if popup_window == 0
    popup_window = popup_locate(cursor_pos.row - 1, cursor_pos.col)
  endif
  return popup_window
enddef

def ScrollInPopup(winid: number, step: number)
  const popup_info = popup_getpos(winid)
  if popup_info.scrollbar == 0
    return
  endif
  const firstline = popup_getoptions(winid).firstline
  if step < 0 && firstline <= abs(step)
    popup_setoptions(winid, {'firstline': 1})
  elseif step > 0 && firstline + step > popup_info.lastline
    return
  else
    popup_setoptions(winid, {'firstline': firstline + step})
  endif
enddef

def ExecuteCmdPvwOrCurrWin(cmd: string, curr_cmd: string)
  const pvw_winid = PreviewWinId()
  const curr_nr = winnr()
  if pvw_winid != 0
    win_execute(pvw_winid, cmd)
  else
    execute curr_cmd
  endif
enddef

export def ClosePopupOrPvw()
  const popup_winid = PopupWindowIdAtCursor()
  if popup_winid != 0
    popup_close(popup_winid)
    return
  endif

  const pvw_winid = PreviewWinId()
  if pvw_winid != 0 && pvw_winid != win_getid()
    win_execute(pvw_winid, 'close!')
  else
    # just Esc press
    execute "normal! \<Esc>"
  endif
enddef

export def ScrolldownOrNextHunk()
  const popup_winid = PopupWindowIdAtCursor()
  if popup_winid != 0
    ScrollInPopup(popup_winid, 5)
  else
    ExecuteCmdPvwOrCurrWin("normal! 3\<C-e>", "normal ]c")
  endif
enddef

export def ScrollupOrPrevHunk()
  const popup_winid = PopupWindowIdAtCursor()
  if popup_winid != 0
    ScrollInPopup(popup_winid, -5)
  else
    ExecuteCmdPvwOrCurrWin("normal! 3\<C-y>", "normal [c")
  endif
enddef
