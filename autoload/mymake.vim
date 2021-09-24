vim9script

const qftitle = '--MYMAKE--'

def mymake#buffer()
    :cclose
    if get(g:, 'myterm_winnr') > 0
        const term_wininfo = getwininfo(win_getid(g:myterm_winnr))
        if !!len(term_wininfo) && !!term_wininfo[0].terminal
            execute(':' .. g:myterm_winnr .. 'wincmd c')
        endif
    endif

    if exists('b:mymake_cmd')
        ProcessCmd(add(split(b:mymake_cmd), expand('%')))
    else
        echo " b:mymake_cmd doesn't setup for this filetype"
    endif
enddef

def mymake#makeprg()
    ProcessCmd(split(&makeprg))
enddef

def ProcessCmd(cmd: list<any>)
    setqflist([], 'r', { title: qftitle })
    var errors = []

    const cur_winnr = winnr()
    execute(':botright :86vnew')
    g:myterm_winnr = winnr()
    const job_id = term_start(cmd, {
            curwin: true,
            exit_cb: (_, _) => {
                const tb = bufnr()
                for term_line in range(1, line('$'))
                    add(errors, term_getline(tb, term_line))
                endfor
                if !empty(errors)
                    errors = getqflist({ efm: &errorformat, lines: errors }).items
                                ->filter((_, v) => v.valid == 1)
                    if !empty(errors)
                        errors->setqflist('r')
                        setqflist([], 'a', { title: qftitle })
                        execute(':' .. g:myterm_winnr .. 'wincmd c')
                        execute('botright copen')
                        execute(':' .. cur_winnr .. 'wincmd w')
                        execute('cc')
                    endif
                endif
            }
        })
enddef

defcompile
