vim9script

def SplitBottom()
    const height = &lines * 2 / 5
    :execute 'silent keepalt botright :' .. height .. 'new'
enddef

def myterm#toggle()
    # if buffer number as g:my_term doesn't exist
    if !bufexists(get(g:, 'my_term', -1))
        SplitBottom()
        :execute 'terminal ++curwin ++kill=kill ++norestore'
        :set nobuflisted
        :set filetype=myterm
        g:my_term = bufnr()
        return
    endif

    const term_winnr = bufwinnr(g:my_term)
    # if buffer number as g:my_term doesn't visible in any window
    if term_winnr == -1
        SplitBottom()
        :execute 'buffer' g:my_term
    else
        if term_winnr == winnr()
        :execute ':' .. winnr('#') .. 'wincmd w'
        endif
        :execute ':' .. term_winnr .. "hide"
    endif
enddef
