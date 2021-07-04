let s:git       = "%1*%{StatusGitBranch()}%*%4*%{StatusGitCommit()}%*%3*%{StatusGitGutter()}%*"
let s:spell     = "%5*%{&spell ? '  SPELL ' : ''}%*"
let s:tail      = " %=%Y  %4*%P%* "
let s:fname     = "  %f %7*%m%* "
let s:ro        = "%6*%{&ro ? '' : ''}%*  "
let s:iminsert  = "%6*%{StatusIminsert()}%*"
" let s:lncol     = "%< %-9(%3*%l%*·%4*%c%V%*%) "
"let s:session - %{fnamemodify(v:this_session, ':t')}

let &statusline = s:iminsert .. s:fname .. s:ro .. s:git .. s:spell .. s:tail

augroup SetStatusLine
  autocmd!
  autocmd FileType fugitiveblame let &l:statusline='%< %(%l/%L%) %=%P '
  autocmd TerminalWinOpen * let &l:statusline='  %f %=%Y '
augroup END

function! StatusGitBranch() abort
  let dir = FugitiveGitDir(bufnr())
  if empty(dir)
    let b:is_in_git = 0
    return ''
  endif
  let b:is_in_git = 1
  return ' ' .. FugitiveHead(7, dir)
endfunction

function! StatusGitCommit() abort
  if !b:is_in_git
    return ' '
  endif

  let commit = matchstr(@%, '\c^fugitive:\%(//\)\=.\{-\}\%(//\|::\)\zs\%(\x\{40,\}\|[0-3]\)\ze\%(/.*\)\=$')
  if len(commit)
    let commit = '·' .. commit[0:6]
  endif
  return commit .. ' '
endfunction

function! StatusGitGutter() abort
  if !b:is_in_git
    return ''
  endif

  let symbols = ['+', '~', '-']
  let changes = join(map(copy(GitGutterGetHunkSummary()), "v:val == 0 ? '' : ' ' .. symbols[v:key] .. v:val"), '')
  return changes
  " return winwidth(winnr()) > 60 ? changes : ''
endfunction

function! StatusIminsert() abort
  return &iminsert ? '   RU ' : ''
endfunction
