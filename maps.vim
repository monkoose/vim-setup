noremap            Q           gq
nnoremap <silent>  <F3>        <Cmd>setlocal spell!<CR>
nnoremap <silent>  <space>/    <Cmd>nohlsearch<CR>
nnoremap           w         <C-w>w
nnoremap <silent>  f         <Cmd>call <SID>InsertSemiColon()<CR>
nnoremap <silent>  <C-n>       <Cmd>call <SID>ScrollDownNextHunk()<CR>
nnoremap <silent>  <C-p>       <Cmd>call <SID>ScrollUpPrevHunk()<CR>
nnoremap <silent>  2         <Cmd>call <SID>ToggleQf()<CR>
nnoremap <silent>  3         <Cmd>call <SID>ToggleLocList()<CR>
nnoremap <silent>  gx          <Cmd>call <SID>OpenPath(expand('<cfile>'))<CR>
nnoremap <silent>  zS          <Cmd>call <SID>SynNames()<CR>
nnoremap           <space>q    <Cmd>pclose<CR>
nnoremap <silent>  <space>a    <Cmd>b#<CR>
nnoremap           <space>d    <C-]>
nnoremap           <space>y    "+y
nnoremap           <space>p    "+
nnoremap           <C-j>       <C-d>
nnoremap           <C-k>       <C-u>
nnoremap <silent>  H           <Cmd>bn<CR>
nnoremap <silent>  L           <Cmd>bp<CR>
nnoremap           q         <C-w>c
nnoremap           o         <C-w>o
nnoremap <silent>  yof         <Cmd>let &foldcolumn = !&foldcolumn<CR>
nnoremap <silent>  yoy         <Cmd>let &cc = &cc == '' ? 100 : ''<CR>
nnoremap <silent>  <C-@>       <Cmd>let &iminsert = !&iminsert<CR>
nnoremap           ;           :
nnoremap           <C-h>       ,
nnoremap           <C-l>       ;

vnoremap           <space>y    "+y
vnoremap           <C-j>       <C-d>
vnoremap           <C-k>       <C-u>
vnoremap           ;           :
vnoremap           <C-h>       ,
vnoremap           <C-l>       ;

noremap!           <C-space>   <C-^>
inoremap           <C-p>       <C-k>
inoremap           h         <Left>
inoremap           l         <Right>
inoremap           f         <Del>
inoremap           <C-u>       <C-g>u<C-u>

cnoremap           <C-n>       <Down>
cnoremap           <C-p>       <Up>
cnoremap           <C-j>       <C-n>
cnoremap           <C-k>       <C-p>
cnoremap           h         <Left>
cnoremap           l         <Right>

set termwinkey=<C-q>
tnoremap           w       <C-q>w
tnoremap <silent>  q       <C-q>c


" Show syntax names
function! s:SynNames() abort
  let synlist = reverse(map(synstack(line('.'), col('.')), 'synIDattr(v:val,"name")'))
  echo ' ' .. join(synlist, ' ')
endfunction


" usage :TTime `times to execute` `any vim command`
" example :TTime 300 call str2nr('3')
function! s:Timer(arg) abort
  let [times; cmd] = split(a:arg)
  let cmd = join(cmd)
  let time = reltime()
  try
    for i in range(times)
      execute cmd
    endfor
  finally
    let result = reltimefloat(reltime(time))
    redraw
    echomsg ' ' .. string(result * 1000) .. 'ms to run :' .. cmd
  endtry
  return ''
endfunction
command! -nargs=1 -complete=command TTime execute s:Timer(<q-args>)


function! s:OpenPath(path) abort
  call job_start(['xdg-open', a:path])
  echohl String
  echo "Open "
  echohl Identifier
  echon a:path
  echohl None
endfunction


function! s:ToggleLocList() abort
  let is_loclist = getwininfo(win_getid())[0].loclist
  if is_loclist
    exec winnr('#') .. "wincmd w"
    lclose
    return
  endif
  try
    lopen
  catch /E776/
      echohl WarningMsg
      echo "Location List is empty"
      echohl None
      return
  endtry
endfunction

function! s:ToggleQf() abort
  let is_qf = getwininfo(win_getid())[0].quickfix
  for win in getwininfo()
    if win.quickfix && !win.loclist
      if is_qf
        exec winnr('#') .. "wincmd w"
      endif
      cclose
      return
    endif
  endfor
  botright copen
endfunction


function! s:PreviewWindowNr(winnrs) abort
  for nr in a:winnrs
    if getwinvar(nr, '&pvw')
      return nr
    endif
  endfor
  return 0
endfunction

function! s:PopupWindowID() abort
  let cursor_pos = screenpos(win_getid(), line('.'), col('.'))
  let popup_window = popup_locate(cursor_pos.row + 1, cursor_pos.col)
  if !popup_window
    let popup_window = popup_locate(cursor_pos.row - 1, cursor_pos.col)
  endif
  return popup_window
endfunction

function! s:ClosePopupWindow() abort
  let popup_winid = s:PopupWindowID()
  if popup_winid
    call popup_close(popup_winid)
  else
    execute "normal! \<Esc>"
  endif
endfunction


function! s:ScrollPopupWindow(winid, step) abort
  let popup_info = popup_getpos(a:winid)
  if !popup_info.scrollbar
    return
  endif
  let firstline = popup_getoptions(a:winid).firstline
  if a:step < 0 && firstline <= abs(a:step)
    call popup_setoptions(a:winid, {'firstline': 1})
  elseif a:step > 0 && firstline + a:step > popup_info.lastline
  else
    call popup_setoptions(a:winid, {'firstline': firstline + a:step})
  endif
endfunction

function! s:CmdPvwOrCurrWin(cmd, curr_cmd) abort
  let winnrs = range(1, winnr('$'))
  let winnr = s:PreviewWindowNr(winnrs)
  let curr_win = winnr()
  if winnr != 0
    try
      execute winnr .. "wincmd w"
      execute a:cmd
    finally
      execute curr_win .. "wincmd w"
    endtry
  else
    execute a:curr_cmd
  endif
endfunction

function! s:ScrollDownNextHunk() abort
  let popup_winid = s:PopupWindowID()
  if popup_winid
    call s:ScrollPopupWindow(popup_winid, 5)
  else
    call s:CmdPvwOrCurrWin("normal! 3\<C-e>", "normal ]c")
  endif
endfunction

function! s:ScrollUpPrevHunk() abort
  let popup_winid = s:PopupWindowID()
  if popup_winid
    call s:ScrollPopupWindow(popup_winid, -5)
  else
    call s:CmdPvwOrCurrWin("normal! 3\<C-y>", "normal [c")
  endif
endfunction


function! s:InsertSemiColon() abort
  let view = winsaveview()
  if match(getline('.'), ';\_$') == -1
    execute 'keepp s/\_$/;/'
  else
    execute 'keepp s/;\_$//'
  endif
  call winrestview(view)
endfunction


" Fix slow esc
nnoremap <silent><nowait>  <Esc>     <Cmd>call <SID>ClosePopupWindow()<CR>
inoremap <nowait>          <Esc>     <Esc>
vnoremap <nowait>          <Esc>     <Esc>
cnoremap <nowait>          <Esc>     <C-c>
tnoremap <nowait>          <Esc>     <Esc>
