vim9script

const git = "%1*%{StatusGitBranch()}%*%4*%{StatusGitCommit()}%* %{StatusGitGutter()}"
const git_nc = "%{StatusGitBranch()}%{StatusGitCommit()}"
const spell = "%5*%{&spell ? '  SPELL ' : ''}%*"
const right = ' %='
const coc = "%7*%{StatusDiagnostic()}%*"
const tail = ' %Y  %4*%P%* '
const tail_nc = ' %=%Y  %P '
const fname = '  %3*%f%* %7*%m%* '
const fname_nc = '  %f %6*%M%*   '
const ro = "%6*%{&ro ? '' : ''}%*  "
const iminsert = "%6*%{StatusIminsert()}%*"
# const lncol = "%< %-9(%3*%l%*·%4*%c%V%*%) "
# const session = "%{fnamemodify(v:this_session, ':t')}"

const hash = '\c^fugitive:\%(//\)\=.\{-\}\%(//\|::\)' ..
             '\zs\%(\x\{40,\}\|[0-3]\)\ze' ..
             '\%(/.*\)\=$'

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

def g:StatusGitBranch(): string
  const dir = g:FugitiveGitDir(bufnr())
  if empty(dir)
    b:is_in_git = 0
    return ''
  endif
  b:is_in_git = 1
  return ' ' .. g:FugitiveHead(7, dir)
enddef

def g:StatusGitCommit(): string
  if !b:is_in_git
    return ' '
  endif

  var commit = matchstr(@%, hash)
  if len(commit)
    commit = '·' .. commit[0 : 6]
  endif
  return commit .. ' '
enddef

def g:StatusGitGutter(): string
  if !b:is_in_git
    return ''
  endif

  const symbols = ['+', '~', '-']
  return g:GitGutterGetHunkSummary()
          ->mapnew((k, v) => v == 0 ? '' : symbols[k] .. v)
          ->join('')
enddef

def g:StatusIminsert(): string
  return &iminsert ? '   RU ' : ''
enddef

def g:StatusDiagnostic(): string
  const info = get(b:, 'coc_diagnostic_info', {})
  if empty(info)
    return ''
  endif

  const msgs = []
  if get(info, 'error')
    call add(msgs, 'E:' .. info.error)
  endif
  if get(info, 'warning')
    call add(msgs, 'W:' .. info.warning)
  endif
  return get(g:, 'coc_status', '') .. ' ' .. join(msgs, ' ')
enddef

defcompile
