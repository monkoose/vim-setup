vim9script

const qftitle = '--MYMAKE--'

def mymake#make(file: number)
    var cmd = split(&makeprg)
    if !!file
        add(cmd, expand('%'))
    endif

    setqflist([], 'r')
    var errors = []
    const errformat = &errorformat
    const job_id = job_start(cmd, {
            err_io: 'out',
            out_cb: (_, m) => add(errors, m),
            exit_cb: (_, _) => {
                if !empty(errors)
                    errors = getqflist({ efm: errformat, lines: errors }).items
                                ->filter((_, v) => v.valid == 1)
                    if !empty(errors)
                        errors->setqflist('r')
                        setqflist([], 'a', { title: qftitle })
                        execute('cwindow')
                    else
                        term_start(cmd)
                    endif
                endif
            }
        })
enddef

defcompile
