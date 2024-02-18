vim9script noclear

const gitgutter = "%{get(b:, 'status_gitgutter', '')}"
const gitcommit = "%{get(b:, 'status_gitcommit', '')}"
const gitbranch = "%{get(b:, 'status_gitbranch', '')}"
const git = $'%1*{gitbranch}%*%4*{gitcommit}%*{gitgutter}'
const git_nc = gitbranch .. gitcommit
const spell = "%5*%{&spell ? '  SPELL ' : ''}%*"
const right = ' %='
const diagnostic = "%{%get(b:, 'status_diagnostics', '')%}"
const encoding = '  %{&fileencoding =~ "\^\$\\|utf-8" ? "" : &fileencoding .. " | "}'
const tail = '%{&filetype}  %4*%P%* '
const tail_nc = '%=%{&filetype}  %P '
const fname = '  %3*%f%* %3(%7*%m%*%) '
const fname_nc = '     %f %M   '
const ro = "%6*%{&ro ? '' : ''}%*  "
const iminsert = "%6*%{get(b:, 'status_iminsert', '')}%*"
const mode = " %2(%{%StatusLineMode()%}%)"
# const lncol = "%< %-9(%3*%l%*·%4*%c%V%*%) "
# const session = "%{fnamemodify(v:this_session, ':t')}"

const statusline = mode .. iminsert .. fname .. ro .. git .. spell .. right .. diagnostic .. encoding .. tail
const statusline_nc = fname_nc .. git_nc .. encoding .. tail_nc

g:qf_disable_statusline = 1
&statusline = '%{%SetStatusline()%}'

def g:StatusIsCurrentWindow(): bool
  return win_getid() == str2nr(g:actual_curwin)
enddef

def g:SetStatusline(): string
  if g:StatusIsCurrentWindow()
    return statusline
  else
    return statusline_nc
  endif
enddef

def StatusGitCommit()
  const buf_name = bufname()
  if match(buf_name, '\c^fugitive:') != -1
    const hash_pattern = '\c\x\{40,}\ze\%(/.*\)\=$'
    const commit = matchstr(buf_name, hash_pattern)
    if !empty(commit)
      b:status_gitcommit = '·' .. commit[0 : 6]
      return
    endif
  endif
  b:status_gitcommit = ''
enddef

def StatusGitBranch()
  const dir = g:FugitiveGitDir(bufnr())
  if empty(dir)
    b:status_gitbranch = ''
  else
    b:status_gitbranch = ' ' .. g:FugitiveHead(7, dir)
  endif
enddef

const symbols = ['+', '~', '-']
def StatusGitGutter()
  b:status_gitgutter = '  ' .. g:GitGutterGetHunkSummary()
                                ->map((k, v) => v == 0 ? '' : symbols[k] .. v)
                                ->join(' ')
enddef

def StatusIminsert()
  b:status_iminsert = &iminsert ? '   RU ' : ''
enddef

const modes = {
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

def StatusDiagnostics()
  const diagnostics = get(b:, 'coc_diagnostic_info')
  var diagn_str = ''
  if !empty(diagnostics)
    if !!diagnostics.error
      diagn_str ..= ' %7*E·' .. diagnostics.error .. '%*'
    endif
    if !!diagnostics.warning
      diagn_str ..= ' %8*W·' .. diagnostics.warning .. '%*'
    endif
  endif
  b:status_diagnostics = diagn_str
enddef

augroup SetStatusLine
  autocmd!
  autocmd FileType fugitiveblame &l:statusline = '%< %(%l/%L%) %=%P '
  autocmd FileType fugitive {
    if bufname() =~ '/\.git//$'
      &l:statusline = "  %{%StatusIsCurrentWindow() ? '%8*GIT STATUS%*' : 'GIT STATUS'%} "
    endif
  }
  autocmd FileType qf {
    &l:statusline = "  %{%StatusIsCurrentWindow() ? '%8*%q%*  %6*%L%*' : '%q  %L'%}  %{get(w:, 'quickfix_title', '')} "
    }
  autocmd TerminalWinOpen * &l:statusline = '  %Y  %4*%{term_gettitle(bufnr())}%* %= %4*%{term_getstatus(bufnr())}%* '
augroup END

augroup StatusLine
  autocmd!
  autocmd User FugitiveChanged,FugitiveObject {
    StatusGitBranch()
    StatusGitCommit()
  }
  autocmd WinEnter,BufWinEnter,FocusGained * {
    if exists('*g:FugitiveGitDir')
      StatusGitBranch()
    endif
  }
  autocmd User CocDiagnosticChange StatusDiagnostics()
  autocmd BufWinEnter * StatusIminsert()
  autocmd OptionSet iminsert StatusIminsert()
  autocmd User GitGutter StatusGitGutter()
augroup END
