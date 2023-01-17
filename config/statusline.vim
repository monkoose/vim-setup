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
const mode = "  %2(%{%StatusLineMode()%}%) "
# const lncol = "%< %-9(%3*%l%*·%4*%c%V%*%) "
# const session = "%{fnamemodify(v:this_session, ':t')}"

const statusline = mode .. iminsert .. fname .. ro .. git .. spell .. right .. coc .. tail
const statusline_nc = fname_nc .. git_nc .. tail_nc
&statusline = statusline

augroup SetStatusLine
  autocmd!
  autocmd WinEnter * SetStatusLine('&l:statusline = statusline')
  autocmd WinLeave,WinNew * SetStatusLine('&l:statusline = statusline_nc')
  autocmd FileType fugitiveblame &l:statusline = '%< %(%l/%L%) %=%P '
  autocmd FileType fern &l:statusline = " %3*%{getcwd()->trim()->fnamemodify(':~')}%* "
  autocmd TerminalWinOpen * &l:statusline = '  %Y  %4*%{term_gettitle(bufnr())}%* %= %4*%{term_getstatus(bufnr())}%* '
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
  const diagn = ale#statusline#Count(bufnr())
  if diagn.total == 0
    b:status_diagnostics = ''
    return
  endif

  var result = ''
  const errors = diagn.error + diagn.style_error
  const warnings = diagn.warning + diagn.style_warning
  if errors > 0
    result ..= 'E:' .. errors
  endif
  if warnings > 0
    result ..= 'W:' .. warnings
  endif
  if diagn.info > 0
    result ..= 'I:' .. diagn.info
  endif
  b:status_diagnostics = result
  echom b:status_diagnostics
enddef

final modes = {
  n: 'N',
  i: '%2*I%*',
  R: 'R',
  v: 'V',
  V: 'VL',
  "\<C-v>": 'VB',
  c: 'C',
  s: 'S',
  S: 'SL',
  "\<C-s>": 'SB',
  t: 'T',
}

def g:StatusLineMode(): string
  return get(modes, mode(), '')
enddef

augroup StatusLine
  autocmd!
  autocmd User FugitiveChanged,FugitiveObject StatusGitBranch()
  autocmd WinEnter,BufWinEnter,FocusGained * StatusGitBranch()
  autocmd User FugitiveChanged,FugitiveObject StatusGitCommit()
  autocmd BufWinEnter * StatusIminsert()
  autocmd OptionSet iminsert StatusIminsert()
  autocmd User GitGutter StatusGitGutter()
  autocmd User ALELintPost StatusDiagnostic()
augroup END
