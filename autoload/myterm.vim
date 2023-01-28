vim9script noclear

final term = {
  bufnr: 0,
  position: '',
  size: 0,
}

def JumpToPrevWindow()
  exe ':' .. winnr('#') .. 'wincmd w'
enddef

def CloseWindow(winnr: number)
  exe ':' .. winnr .. 'close'
enddef


def AdjustTermProperties()
  const win_width = winwidth(0)
  if win_width < &columns
    term.position = 'vertical botright'
    term.size = win_width
  else
    term.position = 'botright'
    term.size = winheight(0)
  endif
enddef

export def Toggle()
  if term.bufnr == 0 || !bufexists(term.bufnr)
    term.size = &lines * 2 / 5
    term.position = 'botright'
    exe $'{term.position} terminal ++kill=kill ++norestore ++rows={term.size}'
    set nobuflisted filetype=myterm
    term.bufnr = bufnr()
    autocmd_add([{
      bufnr: term.bufnr,
      event: 'WinLeave',
      group: 'MyTermToggle',
      cmd: 'AdjustTermProperties()',
      replate: true,
    }])
    return
  endif

  const term_winnr = bufwinnr(term.bufnr)
  if term_winnr == -1 # if term window isn't present
    exe $'{term.position} :{term.size}split'
    exe $':{term.bufnr}buffer'
  else
    if term_winnr == winnr()
      JumpToPrevWindow()
    endif
    CloseWindow(term_winnr)
  endif
enddef
