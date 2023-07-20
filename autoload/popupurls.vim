vim9script

import autoload '../autoload/mypopup.vim'
import autoload '../autoload/myfunctions.vim' as mf

def BufferMatches(
    pattern: string,
    bufnr: number = bufnr(),
    first: number = 1,
    last: any = "$"
): list<string>
  final urls: list<string> = []
  for line in getbufline(bufnr, first, last)
    var match = matchstrpos(line, pattern)
    while match[1] != -1
      add(urls, match[0])
      match = matchstrpos(line, pattern, match[2])
    endwhile
  endfor
  return urls
enddef

def PopupUrls(): list<string>
  const winid = mypopup.PopupWindowId()
  if winid != 0
    const url_pattern = 'https\?://\%(www\.\)\?[-[:alnum:]@:%._+~#=]\{1,256}\.[[:alnum:]]\{1,6}[[:alnum:]-@:%_+.~#?&/=]*'
    const opts = popup_getpos(winid)
    return BufferMatches(url_pattern, winbufnr(winid), opts.firstline, opts.lastline)
  endif
  return []
enddef

export def Open()
  var urls = PopupUrls()
  if empty(urls)
    return
  endif

  if len(urls) == 1
    mf.OpenPath(urls[0])
  else
    popup_menu(urls, {
      borderhighlight: ["PopupBorder"],
      borderchars: ['━', '┃', '━', '┃', '┏', '┓', '┛', '┗'],
      highlight: "Normal",
      title: "━━━ Select url ",
      callback: (_, n) => {
        if n > 0
          mf.OpenPath(urls[n - 1])
        endif
      },
    })
  endif
enddef
