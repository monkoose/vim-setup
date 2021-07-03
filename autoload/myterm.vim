vim9script

def myterm#toggle()
  const height = &lines * 2 / 5
  if !bufexists(get(g:, 'my_term', -1))
    :execute 'silent keepalt botright :' .. height .. 'split'
    :execute 'terminal ++curwin ++kill=kill ++norestore'
    :set nobuflisted
    :set filetype=myterm
    g:my_term = bufnr()
    return
  endif

  const term_winnr = bufwinnr(g:my_term)
  if term_winnr == -1
    :execute 'silent keepalt botright :' .. height .. 'split'
    :execute 'buffer' g:my_term
  else
    if term_winnr == winnr()
      :execute ':' .. winnr('#') .. 'wincmd w'
    endif
    :execute ':' .. term_winnr .. "hide"
  endif
enddef
