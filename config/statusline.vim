vim9script

const gitgutter = "%{get(b:, 'status_gitgutter', '')}"
const gitcommit = "%{get(b:, 'status_gitcommit', '')}"
const gitbranch = "%{get(b:, 'status_gitbranch', '')}"
const git = "%1*" .. gitbranch .. "%*%4*" .. gitcommit .. "%*" .. gitgutter
const git_nc = gitbranch .. gitcommit
const spell = "%5*%{&spell ? '  SPELL ' : ''}%*"
const right = ' %='
const coc = "%{get(g:, 'coc_status', '')} %7*%{get(b:, 'status_diagnostics', '')}%*"
const tail = '  %Y  %4*%P%* '
const tail_nc = ' %=%Y  %P '
const fname = '  %3*%f%* %7*%m%* '
const fname_nc = '  %f %6*%M%*   '
const ro = "%6*%{&ro ? '' : ''}%*  "
const iminsert = "%6*%{get(b:, 'status_iminsert', '')}%*"
# const lncol = "%< %-9(%3*%l%*·%4*%c%V%*%) "
# const session = "%{fnamemodify(v:this_session, ':t')}"

const statusline = iminsert .. fname .. ro .. git .. spell .. right .. coc .. tail
const statusline_nc = fname_nc .. git_nc .. tail_nc
&statusline = statusline

augroup SetStatusLine
  autocmd!
  autocmd WinEnter * call SetStatusLine('&l:statusline = statusline')
  autocmd WinLeave,WinNew * call SetStatusLine('&l:statusline = statusline_nc')
  autocmd FileType fugitiveblame &l:statusline = '%< %(%l/%L%) %=%P '
  autocmd FileType fern &l:statusline = " %3*%{getcwd()->trim()->fnamemodify(':~')}%* "
  autocmd TerminalWinOpen * &l:statusline = '  %Y %= %4*%{term_getstatus(bufnr())}%* '
augroup END

def SetStatusLine(cmd: string): void
  if index(['fugitiveblame', 'fern'], &filetype) != -1
    return
  endif

  const win_info = getwininfo(win_getid())[0]
  if win_info.quickfix || win_info.terminal
    return
  endif

  execute cmd
enddef

def StatusGitBranch()
  const dir = g:FugitiveGitDir(bufnr())
  if empty(dir)
    b:status_gitbranch = ''
  else
    b:status_gitbranch = ' ' .. g:FugitiveHead(7, dir)
  endif
enddef

def StatusGitCommit()
  const buf_name = bufname()
  if match(buf_name, '\c^fugitive:') != -1
    const hash_pattern = '\c\x\{40,\}\ze\%(/.*\)\=$'
    const commit = matchstr(buf_name, hash_pattern)
    if !empty(commit)
      b:status_gitcommit = '·' .. commit[0 : 6]
      return
    endif
  endif
  b:status_gitcommit = ''
enddef

def StatusGitGutter()
  const symbols = ['+', '~', '-']
  b:status_gitgutter = '  ' .. g:GitGutterGetHunkSummary()
                            ->mapnew((k, v) => v == 0 ? '' : symbols[k] .. v)
                            ->join(' ')
enddef

def StatusIminsert()
  b:status_iminsert = &iminsert ? '   RU ' : ''
enddef

def StatusDiagnostic()
  const info = get(b:, 'coc_diagnostic_info', {})
  if empty(info)
    b:status_diagnostics = ''
    return
  endif

  final msgs = []
  if get(info, 'error', 0) > 0
    add(msgs, 'E:' .. info.error)
  endif
  if get(info, 'warning', 0) > 0
    add(msgs, 'W:' .. info.warning)
  endif
  b:status_diagnostics = join(msgs, ' ')
enddef

augroup StatusLine
  autocmd!
  autocmd User FugitiveChanged,FugitiveObject call StatusGitBranch()
  autocmd WinEnter,BufWinEnter,FocusGained * call StatusGitBranch()
  autocmd User FugitiveChanged,FugitiveObject call StatusGitCommit()
  autocmd BufWinEnter * call StatusIminsert()
  autocmd OptionSet iminsert call StatusIminsert()
  autocmd User GitGutter call StatusGitGutter()
  autocmd User CocDiagnosticChange call StatusDiagnostic()
augroup END

defcompile
