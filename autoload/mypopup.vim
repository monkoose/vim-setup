vim9script

def PreviewWindowNr(): number
    for nr in range(1, winnr('$'))
        if getwinvar(nr, '&pvw')
            return nr
        endif
    endfor
    return 0
enddef

def PopupWindowIdAtCursor(): number
    const cursor_pos = screenpos(win_getid(), line('.'), col('.'))
    var popup_window = popup_locate(cursor_pos.row + 1, cursor_pos.col)
    if !popup_window
        popup_window = popup_locate(cursor_pos.row - 1, cursor_pos.col)
    endif
    return popup_window
enddef

def ScrollInPopup(winid: number, step: number)
    const popup_info = popup_getpos(winid)
    if !popup_info.scrollbar
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
    const pvw_nr = PreviewWindowNr()
    const curr_nr = winnr()
    if !!pvw_nr
        try
            execute ':' .. pvw_nr .. 'wincmd w'
            execute cmd
        finally
            execute ':' .. curr_nr .. 'wincmd w'
        endtry
    else
        execute curr_cmd
    endif
enddef

export def Close_popup_atcursor()
    const popup_winid = PopupWindowIdAtCursor()
    if !!popup_winid
        popup_close(popup_winid)
    else
        # just Esc press
        execute "normal! \<Esc>"
    endif
enddef

export def Scrolldown_or_next_hunk()
    const popup_winid = PopupWindowIdAtCursor()
    if !!popup_winid
        ScrollInPopup(popup_winid, 5)
    else
        ExecuteCmdPvwOrCurrWin("normal! 3\<C-e>", "normal ]c")
    endif
enddef

export def Scrollup_or_prev_hunk()
    const popup_winid = PopupWindowIdAtCursor()
    if !!popup_winid
        ScrollInPopup(popup_winid, -5)
    else
        ExecuteCmdPvwOrCurrWin("normal! 3\<C-y>", "normal [c")
    endif
enddef

defcompile
