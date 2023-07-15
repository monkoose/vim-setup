vim9script

import autoload '../autoload/mypopup.vim'
import autoload '../autoload/myfunctions.vim' as mf

export def Open()
  const urls = mypopup.PopupUrls()
  if empty(urls)
    return
  endif

  if len(urls) == 1
    mf.OpenPath(urls[0])
  else
    # TODO: open in fzf multiple urls
    echow urls
  endif
enddef
