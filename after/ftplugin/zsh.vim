vim9script

const name = expand('%:p:~')
if expand('%:p:~') =~# '\~/\.\%(zprofile\|zshrc\|zshenv\)'
  def Zcompile(filename: string)
    job_start(['/bin/zsh', '-c', 'zcompile ' .. filename], {
      exit_cb: (_, s) => {
        if s == 0
          echow "File have been compiled."
        endif
      },
      err_cb: (_, m) => {
        echohl ErrorMsg
        echom m
        echohl None
      },
    })
  enddef
  augroup zsh_compile
    autocmd! BufWritePost <buffer>
    autocmd BufWritePost <buffer> Zcompile(expand('<afile>:p'))
  augroup END
endif
