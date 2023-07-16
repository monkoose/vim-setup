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
    const i = urls
                ->mapnew((i, v) => $" \e[33m{i + 1}. \e[32m{v}\e[0m")
                ->insert("\e[1;33mSelect url:\e[0m")
                ->inputlist()
    if i > 0
      mf.OpenPath(urls[i - 1])
    endif
  endif
enddef
