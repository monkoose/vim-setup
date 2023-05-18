vim9script noclear

const step = 3

def PreviewWinId(): number
  for nr in range(1, winnr('$'))
    if win_gettype(nr) == 'preview'
      return win_getid(nr)
    endif
  endfor
  return 0
enddef

def PopupWindowId(): number
  const popups = popup_list()
  for id in popups
    if popup_getpos(id).visible
      return id
    endif
  endfor
  return 0
enddef

def ScrollPopup(winid: number, amount: number)
  const pinfo = popup_getpos(winid)
  const bufinfo = getbufinfo(winbufnr(winid))[0]
  # If all lines are visible don't do anything
  if pinfo.core_height >= bufinfo.linecount
    return
  endif

  const new_firstline = pinfo.firstline + amount
  if new_firstline < 1
    popup_setoptions(winid, {'firstline': 1})
  elseif bufinfo.linecount - new_firstline < pinfo.core_height
    popup_setoptions(winid, {
      'firstline': max([1, bufinfo.linecount - pinfo.core_height + 1])
    })
  else
    popup_setoptions(winid, {'firstline': new_firstline})
  endif
enddef

def ExePopupOrPvwOrCur(PopupCb: func(number), PvwCb: func(number), CurCb: func())
  const popup_winid = PopupWindowId()
  if popup_winid != 0
    PopupCb(popup_winid)
    return
  endif

  const pvw_winid = PreviewWinId()
  if pvw_winid != 0
    PvwCb(pvw_winid)
    return
  endif

  CurCb()
enddef

export def ClosePopupOrPvwOrPressEsc()
  ExePopupOrPvwOrCur(
    (winid) => {
      popup_close(winid)
    },
    (winid) => {
      if winid != win_getid()
        pclose!
      endif
    },
    () => {
      feedkeys("\<Esc>", 'nt')
    }
  )
enddef

export def ScrollDownOrJumpNextHunk()
  ExePopupOrPvwOrCur(
    (winid) => ScrollPopup(winid, step),
    (winid) => {
      win_execute(winid, $"normal! {step}\<C-e>", 'silent')
    },
    () => {
      :GitGutterNextHunk
    }
  )
enddef

export def ScrollUpOrJumpPrevHunk()
  ExePopupOrPvwOrCur(
    (winid) => ScrollPopup(winid, -step),
    (winid) => {
      win_execute(winid, $"normal! {step}\<C-y>", 'silent')
    },
    () => {
      :GitGutterPrevHunk
    }
  )
enddef

defcompile
