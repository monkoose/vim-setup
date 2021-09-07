vim9script

const qftitle = '--MYMAKE--'

def mymake#buffer()
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

    const job_id = job_start(cmd, {
            err_io: 'out',
            out_cb: (_, m) => add(errors, m),
            exit_cb: (_, _) => {
                if !empty(errors)
                    errors = getqflist({ efm: &errorformat, lines: errors }).items
                                ->filter((_, v) => v.valid == 1)
                    if !empty(errors)
                        errors->setqflist('r')
                        setqflist([], 'a', { title: qftitle })
                        execute('botright copen')
                        execute('wincmd p')
                        execute('cc')
                    else
                        execute('cclose')
                        term_start(cmd)
                    endif
                else
                    execute('cclose')
                endif
            }
        })
enddef

defcompile
