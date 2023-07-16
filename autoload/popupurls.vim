vim9script

import autoload '../autoload/mypopup.vim'
import autoload '../autoload/myfunctions.vim' as mf

export def Open()
  var urls = mypopup.PopupUrls()
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
