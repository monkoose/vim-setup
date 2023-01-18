vim9script

g:loaded_fastfold = 1
if exists('g:loaded_fastfold')
  finish
endif

g:loaded_fastfold = 1

# Options {{{
g:fastfold_fdmhook = get(g:, 'fastfold_fdmhook', 0)
g:fastfold_savehook = get(g:, 'fastfold_savehook', 1)
g:fastfold_force = get(g:, 'fastfold_force', 0)
g:fastfold_skip_filetypes = get(g:, 'fastfold_skip_filetypes', [])
g:fastfold_minlines = get(g:, 'fastfold_minlines', 100)
g:fastfold_fold_command_suffixes = get(g:,
  'fastfold_fold_command_suffixes', ['x', 'X', 'a', 'A', 'o', 'O', 'c', 'C'])
g:fastfold_fold_movement_commands = get(g:,
  'fastfold_fold_movement_commands', [']z', '[z', 'zj', 'zk'])
# }}}

def EnterWin()
  if Skip()
    if exists('w:lastfdm')
      unlet w:lastfdm
    endif
  else
    w:lastfdm = &l:foldmethod
    setlocal foldmethod=manual
  endif
enddef

def LeaveWin()
  echom 'hello'
  if exists('w:predifffdm')
    if empty(&l:foldmethod) || &l:foldmethod == 'manual'
      &l:foldmethod = w:predifffdm
      unlet w:predifffdm
      return
    elseif &l:foldmethod != 'diff'
      unlet w:predifffdm
    endif
  endif

  if exists('w:lastfdm')
    if &l:foldmethod == 'diff'
      w:predifffdm = w:lastfdm
    elseif &l:foldmethod == 'manual'
      &l:foldmethod = w:lastfdm
    endif
  endif
enddef

def WinDo(command: string)
  const winids: list<number> = gettabinfo(0)[0].windows
  execute(command)
  for winid in winids
    win_execute(winid, 'keepjumps noautocmd ' .. command)
  endfor
enddef

# WinEnter then TabEnter then BufEnter then BufWinEnter
def UpdateWin()
  const curwin: number = winnr()
  WinDo('if winnr() == ' .. curwin .. ' | LeaveWin() | endif')
  WinDo('if winnr() == ' .. curwin .. ' | EnterWin() | endif')
enddef

def g:UpdateBuf(feedback: bool)
  # skip if another session still loading
  if exists('g:SessionLoad') | return | endif

  const curbuf: number = bufnr()
  WinDo('if bufnr() == ' .. curbuf .. ' | LeaveWin() | endif')
  WinDo('if bufnr() == ' .. curbuf .. ' | EnterWin() | endif')

  if !feedback | return | endif

  if !exists('w:lastfdm')
    echomsg "'" .. &l:foldmethod .. "' folds already continuously updated"
  else
    echomsg "updated '" .. w:lastfdm .. "' folds"
  endif
enddef

def UpdateTab()
  # skip if another session still loading
  if exists('g:SessionLoad') | return | endif

  WinDo('LeaveWin()')
  WinDo('EnterWin()')
enddef

def Skip(): bool
  if IsSmall() || !IsReasonable() || InSkipList() ||
      !empty(&l:buftype) || !&l:modifiable
    return true
  else
    return false
  endif
enddef

def IsReasonable(): bool
  if (&l:foldmethod == 'syntax' || &l:foldmethod == 'expr') || g:fastfold_force == 1
    return true
  else
    return false
  endif
enddef

def InSkipList(): bool
  if index(g:fastfold_skip_filetypes, &l:filetype) >= 0
    return true
  else
    return false
  endif
enddef

def IsSmall(): bool
  if line('$') <= g:fastfold_minlines
    return true
  else
    return false
  endif
enddef

command! -bar -bang FastFoldUpdate g:UpdateBuf(<bang>0)

nnoremap <silent> <Plug>(FastFoldUpdate) <ScriptCmd>FastFoldUpdate!<CR>

if !hasmapto('<Plug>(FastFoldUpdate)', 'n') && empty(mapcheck('zuz', 'n'))
  nmap zuz <Plug>(FastFoldUpdate)
endif

for suffix in g:fastfold_fold_command_suffixes
  exe 'nnoremap <silent> z' .. suffix .. ' <ScriptCmd>UpdateWin()<CR>z' .. suffix
endfor

for cmd in g:fastfold_fold_movement_commands
  exe "nnoremap <silent><expr> " .. cmd .. " '<ScriptCmd>UpdateWin()<CR>' .. v:count .. " .. "'" .. cmd .. "'"
  exe "xnoremap <silent><expr> " .. cmd .. " '<ScriptCmd>UpdateWin()<CR>gv' .. v:count .. " .. "'" .. cmd .. "'"
  exe "onoremap <silent><expr> " .. cmd ..
    " '<ScriptCmd>UpdateWin()<CR>' .. '\"' .. v:register .. v:operator .. v:count1 .. " .. "'" .. cmd .. "'"
endfor

augroup FastFold
  autocmd!
  autocmd VimEnter * Init()
augroup end

def OnWinEnter()
  w:winenterbuf = bufnr()
  if exists('b:lastfdm')
    w:lastfdm = b:lastfdm
  endif
enddef

def OnBufEnter()
  if exists('w:winenterbuf')
    if w:winenterbuf != bufnr()
      unlet! w:lastfdm
    endif
    unlet w:winenterbuf
  endif

  # Update folds after entering a changed buffer
  if !exists('b:lastchangedtick')
    b:lastchangedtick = b:changedtick
  endif
  if b:changedtick != b:lastchangedtick &&
      (&l:foldmethod != 'diff' && exists('b:predifffdm'))
    g:UpdateBuf(false)
  endif
enddef

def OnWinLeave()
  if exists('w:lastfdm')
    b:lastfdm = w:lastfdm
  elseif exists('b:lastfdm')
    unlet b:lastfdm
  endif

  if exists('w:predifffdm')
    b:predifffdm = w:predifffdm
  elseif exists('b:predifffdm')
    unlet b:predifffdm
  endif
enddef

def OnBufWinEnter()
  if !exists('b:fastfold')
    g:UpdateBuf(false)
    b:fastfold = 1
  endif
enddef

def Init()
  UpdateTab()

  augroup FastFoldEnter
    autocmd!
    # Make foldmethod local to buffer instead of window
    autocmd WinEnter * OnWinEnter()
    autocmd BufEnter * OnBufEnter()
    autocmd WinLeave * OnWinLeave()
    # Update folds after foldmethod set by filetype autocmd
    autocmd FileType * g:UpdateBuf(false)
    # Update folds after foldmethod set by :loadview or :source Session.vim
    autocmd SessionLoadPost * g:UpdateBuf(false)
    # Update folds after foldmethod set by modeline
    if g:fastfold_fdmhook
      autocmd OptionSet foldmethod g:UpdateBuf(false)
      autocmd BufRead * g:UpdateBuf(false)
    else
      autocmd BufWinEnter * OnBufWinEnter()
    endif
    # Update folds after entering a changed buffer
    autocmd BufLeave * b:lastchangedtick = b:changedtick
    # Update folds after saving
    if g:fastfold_savehook
      autocmd BufWritePost * g:UpdateBuf(false)
    endif
  augroup end
enddef

# vim: fdm=marker
