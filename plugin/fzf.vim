" Copyright (c) 2013-2023 Junegunn Choi
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

if exists('g:loaded_fzf')
  finish
endif

let g:loaded_fzf = 1

if has('win32') || has('win64') || (!has('gui_running') && exists('$TMUX'))
  unlet! g:loaded_fzf
  exe $'source {$VIM}/vimfiles/plugin/fzf.vim'
  finish
endif

let s:term_marker = ";#FZF"

function! s:fzf_call(fn, ...)
  return call(a:fn, a:000)
endfunction

function! fzf#shellescape(arg, shell = 'sh')
  let shell = a:shell
  try
    let [shell, &shell] = [&shell, shell]
    return s:fzf_call('shellescape', a:arg)
  finally
    let [shell, &shell] = [&shell, shell]
  endtry
endfunction

function! s:fzf_expand(fmt)
  return s:fzf_call('expand', a:fmt, 1)
endfunction

let s:layout_keys = ['window', 'up', 'down', 'left', 'right']

let s:cpo_save = &cpo
set cpo&vim

let s:default_layout = { 'window' : { 'width': 0.9, 'height': 0.6 } }

let s:versions = {}
function s:get_version(bin)
  if has_key(s:versions, a:bin)
    return s:versions[a:bin]
  end
  let command = s:fzf_call('shellescape', a:bin) .. ' --version --no-height'
  let output = systemlist(command)
  if v:shell_error || empty(output)
    return ''
  endif
  let ver = matchstr(output[-1], '[0-9.]\+')
  let s:versions[a:bin] = ver
  return ver
endfunction

function! s:compare_versions(a, b)
  let a = split(a:a, '\.')
  let b = split(a:b, '\.')
  for idx in range(0, max([len(a), len(b)]) - 1)
    let v1 = str2nr(get(a, idx, 0))
    let v2 = str2nr(get(b, idx, 0))
    if     v1 < v2 | return -1
    elseif v1 > v2 | return 1
    endif
  endfor
  return 0
endfunction

let s:checked = {}
function! fzf#exec(...)
  if !exists('s:exec')
    let s:exec = 'fzf'
    if !executable(s:exec)
      throw 'fzf executable not found'
    endif
  endif

  if a:0 && !has_key(s:checked, a:1)
    let fzf_version = s:get_version(s:exec)
    if empty(fzf_version)
      let message = $'Failed to run "{s:exec} --version"'
      unlet s:exec
      throw message
    end

    if s:compare_versions(fzf_version, a:1) >= 0
      let s:checked[a:1] = 1
      return s:exec
    else
      throw printf('You need to upgrade fzf (required: %s or above)', a:1)
    endif
  endif

  return s:exec
endfunction

function! s:error(msg)
  echohl ErrorMsg
  echom a:msg
  echohl None
endfunction

function! s:warn(msg)
  echohl WarningMsg
  echom a:msg
  echohl None
endfunction

function! s:has_any(dict, keys)
  for key in a:keys
    if has_key(a:dict, key)
      return 1
    endif
  endfor
  return 0
endfunction

function! s:open(cmd, target)
  if stridx('edit', a:cmd) == 0 && fnamemodify(a:target, ':p') ==# s:fzf_expand('%:p')
    return
  endif
  execute a:cmd fnameescape(a:target)
endfunction

function! s:common_sink(action, lines) abort
  if len(a:lines) < 2
    return
  endif
  let key = remove(a:lines, 0)
  let Cmd = get(a:action, key, 'e')
  if type(Cmd) == type(function('call'))
    return Cmd(a:lines)
  endif
  if len(a:lines) > 1
    augroup fzf_swap
      autocmd SwapExists * let v:swapchoice='o'
            \| call s:warn('fzf: E325: swap file exists: ' .. s:fzf_expand('<afile>'))
    augroup END
  endif
  try
    let empty = empty(s:fzf_expand('%')) && line('$') == 1 && empty(getline(1)) && !&modified
    " Preserve the current working directory in case it's changed during
    " the execution (e.g. `set autochdir` or `autocmd BufEnter * lcd ...`)
    let cwd = exists('w:fzf_pushd') ? w:fzf_pushd.dir : expand('%:p:h')
    for item in a:lines
      if item[0] != '~' && item !~ '^/'
        let sep = '/'
        let item = join([cwd, item], cwd[len(cwd)-1] == sep ? '' : sep)
      endif
      if empty
        execute $'edit {fnameescape(item)}'
        let empty = 0
      else
        call s:open(Cmd, item)
      endif
    endfor
  catch /^Vim:Interrupt$/
  finally
    silent! autocmd! fzf_swap
  endtry
endfunction

function! s:get_color(attr, ...)
  " Force 24 bit colors: g:fzf_force_termguicolors (temporary workaround for https://github.com/junegunn/fzf.vim/issues/1152)
  let gui = get(g:, 'fzf_force_termguicolors', 0) || &termguicolors
  let fam = gui ? 'gui' : 'cterm'
  let pat = gui ? '^#[a-f0-9]\+' : '^[0-9]\+$'
  for group in a:000
    let code = synIDattr(synIDtrans(hlID(group)), a:attr, fam)
    if code =~? pat
      return code
    endif
  endfor
  return ''
endfunction

function! s:defaults()
  let rules = copy(get(g:, 'fzf_colors', {}))
  let colors = join(map(items(filter(map(rules, 'call("s:get_color", v:val)'), '!empty(v:val)')), 'join(v:val, ":")'), ',')
  return empty(colors) ? '' : fzf#shellescape('--color=' .. colors)
endfunction

function! s:validate_layout(layout)
  for key in keys(a:layout)
    if index(s:layout_keys, key) < 0
      throw printf('Invalid entry in g:fzf_layout: %s (allowed: %s)%s',
            \ key, join(s:layout_keys, ', '), key == 'options' ? '. Use $FZF_DEFAULT_OPTS.' : '')
    endif
  endfor
  return a:layout
endfunction

function! s:evaluate_opts(options)
  return type(a:options) == type([]) ?
        \ join(map(copy(a:options), 'fzf#shellescape(v:val)')) : a:options
endfunction

" [name string,] [opts dict,] [fullscreen boolean]
function! fzf#wrap(...)
  let args = ['', {}, 0]
  let expects = map(copy(args), 'type(v:val)')
  let tidx = 0
  for arg in copy(a:000)
    let tidx = index(expects, type(arg) == 6 ? type(0) : type(arg), tidx)
    if tidx < 0
      throw 'Invalid arguments (expected: [name string] [opts dict] [fullscreen boolean])'
    endif
    let args[tidx] = arg
    let tidx += 1
    unlet arg
  endfor
  let [name, opts, bang] = args

  if len(name)
    let opts.name = name
  end

  " Layout: g:fzf_layout (and deprecated g:fzf_height)
  if bang
    for key in s:layout_keys
      if has_key(opts, key)
        call remove(opts, key)
      endif
    endfor
  elseif !s:has_any(opts, s:layout_keys)
    if !exists('g:fzf_layout') && exists('g:fzf_height')
      let opts.down = g:fzf_height
    else
      let opts = extend(opts, s:validate_layout(get(g:, 'fzf_layout', s:default_layout)))
    endif
  endif

  " Colors: g:fzf_colors
  let opts.options = s:defaults() .. ' ' .. s:evaluate_opts(get(opts, 'options', ''))

  " History: g:fzf_history_dir
  if len(name) && len(get(g:, 'fzf_history_dir', ''))
    let dir = s:fzf_expand(g:fzf_history_dir)
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
    let history = fzf#shellescape($'{dir}/{name}')
    let opts.options = join(['--history', history, opts.options])
  endif

  " Action: g:fzf_action
  if !s:has_any(opts, ['sink', 'sinklist', 'sink*'])
    let opts._action = get(g:, 'fzf_action', s:default_action)
    let opts.options ..= ' --expect=' .. join(keys(opts._action), ',')
    function! opts.sinklist(lines) abort
      return s:common_sink(self._action, a:lines)
    endfunction
    let opts['sink*'] = opts.sinklist " For backward compatibility
  endif

  return opts
endfunction

function! s:use_sh()
  let [shell, shellslash, shellcmdflag, shellxquote] = [&shell, &shellslash, &shellcmdflag, &shellxquote]
  set shell=sh
  return [shell, shellslash, shellcmdflag, shellxquote]
endfunction

function! s:writefile(...)
  if call('writefile', a:000) == -1
    throw 'Failed to write temporary file. Check if you can write to the path tempname() returns.'
  endif
endfunction

function! fzf#run(...) abort
try
  let [shell, shellslash, shellcmdflag, shellxquote] = s:use_sh()

  let dict   = exists('a:1') ? copy(a:1) : {}
  let temps  = { 'result': tempname() }
  let optstr = s:evaluate_opts(get(dict, 'options', ''))
  try
    let fzf_exec = shellescape(fzf#exec())
  catch
    throw v:exception
  endtry

  if !s:present(dict, 'dir')
    let dict.dir = getcwd()
  endif

  if has_key(dict, 'source')
    let source = remove(dict, 'source')
    let type = type(source)
    if type == 1
      let source_command = source
    elseif type == 3
      let temps.input = tempname()
      call s:writefile(source, temps.input)
      let source_command = 'cat ' .. fzf#shellescape(temps.input)
    else
      throw 'Invalid source type'
    endif
  else
    let source_command = ''
  endif

  let use_height = has_key(dict, 'down') && !has('gui_running') &&
        \ s:present(dict, 'up', 'left', 'right', 'window') &&
        \ executable('tput') && filereadable('/dev/tty')
  let use_term = 1
  let optstr ..= ' --no-height'
  " Respect --border option given in 'options'
  let optstr = join([s:border_opt(get(dict, 'window', 0)), optstr])
  let prev_default_command = $FZF_DEFAULT_COMMAND
  if len(source_command)
    let $FZF_DEFAULT_COMMAND = source_command
  endif
  let command = $'{fzf_exec} {optstr} > {temps.result}'

  if use_term
    return s:execute_term(dict, command, temps)
  endif

  let lines = s:execute(dict, command, use_height, temps)
  call s:callback(dict, lines)
  return lines
finally
  if exists('source_command') && len(source_command)
    if len(prev_default_command)
      let $FZF_DEFAULT_COMMAND = prev_default_command
    else
      let $FZF_DEFAULT_COMMAND = ''
      silent! execute 'unlet $FZF_DEFAULT_COMMAND'
    endif
  endif
  let [&shell, &shellslash, &shellcmdflag, &shellxquote] = [shell, shellslash, shellcmdflag, shellxquote]
endtry
endfunction

function! s:present(dict, ...)
  for key in a:000
    if !empty(get(a:dict, key, ''))
      return 1
    endif
  endfor
  return 0
endfunction

function! s:splittable(dict)
  return s:present(a:dict, 'up', 'down') && &lines > 15 ||
        \ s:present(a:dict, 'left', 'right') && &columns > 40
endfunction

function! s:pushd(dict)
  if s:present(a:dict, 'dir')
    let cwd = getcwd()
    let w:fzf_pushd = {
    \   'command': haslocaldir() ? 'lcd' : (exists(':tcd') && haslocaldir(-1) ? 'tcd' : 'cd'),
    \   'origin': cwd,
    \   'bufname': bufname('')
    \ }
    execute 'lcd' fnameescape(a:dict.dir)
    let cwd = getcwd()
    let w:fzf_pushd.dir = cwd
    let a:dict.pushd = w:fzf_pushd
    return cwd
  endif
  return ''
endfunction

augroup fzf_popd
  autocmd!
  autocmd WinEnter * call s:dopopd()
augroup END

function! s:dopopd()
  if !exists('w:fzf_pushd')
    return
  endif

  " FIXME: We temporarily change the working directory to 'dir' entry
  " of options dictionary (set to the current working directory if not given)
  " before running fzf.
  "
  " e.g. call fzf#run({'dir': '/tmp', 'source': 'ls', 'sink': 'e'})
  "
  " After processing the sink function, we have to restore the current working
  " directory. But doing so may not be desirable if the function changed the
  " working directory on purpose.
  "
  " So how can we tell if we should do it or not? A simple heuristic we use
  " here is that we change directory only if the current working directory
  " matches 'dir' entry. However, it is possible that the sink function did
  " change the directory to 'dir'. In that case, the user will have an
  " unexpected result.
  if getcwd() ==# w:fzf_pushd.dir && (!&autochdir || w:fzf_pushd.bufname ==# bufname(''))
    execute w:fzf_pushd.command fnameescape(w:fzf_pushd.origin)
  endif
  unlet! w:fzf_pushd
endfunction

function! s:xterm_launcher()
  let fmt = 'xterm -T "[fzf]" -bg "%s" -fg "%s" -geometry %dx%d+%d+%d -e bash -ic %%s'
  return printf(fmt,
    \ escape(synIDattr(hlID("Normal"), "bg"), '#'), escape(synIDattr(hlID("Normal"), "fg"), '#'),
    \ &columns, &lines/2, getwinposx(), getwinposy())
endfunction
unlet! s:launcher
let s:launcher = function('s:xterm_launcher')

function! s:exit_handler(code, command, ...)
  if a:code == 130
    return 0
  elseif a:code > 1
    call s:error('Error running ' .. a:command)
    if !empty(a:000)
      sleep
    endif
    return 0
  endif
  return 1
endfunction

function! s:execute(dict, command, use_height, temps) abort
  call s:pushd(a:dict)
  if !a:use_height
    silent! !clear 2> /dev/null
  endif
  let escaped = a:use_height ? a:command : escape(substitute(a:command, '\n', '\\n', 'g'), '%#!')
  if has('gui_running')
    let Launcher = get(a:dict, 'launcher', get(g:, 'Fzf_launcher', get(g:, 'fzf_launcher', s:launcher)))
    let fmt = type(Launcher) == 2 ? call(Launcher, []) : Launcher
    let escaped = "'" .. substitute(escaped, "'", "'\"'\"'", 'g') .. "'"
    let command = printf(fmt, escaped)
  else
    let command = escaped
  endif
  if a:use_height
    call system(printf('tput cup %d > /dev/tty; tput cnorm > /dev/tty; %s < /dev/tty 2> /dev/tty', &lines, command))
  else
    execute $'silent !{command}'
  endif
  let exit_status = v:shell_error
  redraw!
  let lines = s:collect(a:temps)
  return s:exit_handler(exit_status, command) ? lines : []
endfunction

function! s:calc_size(max, val, dict)
  let val = substitute(a:val, '^\~', '', '')
  if val =~ '%$'
    let size = a:max * str2nr(val[:-2]) / 100
  else
    let size = min([a:max, str2nr(val)])
  endif

  let srcsz = -1
  if type(get(a:dict, 'source', 0)) == type([])
    let srcsz = len(a:dict.source)
  endif

  let opts = $FZF_DEFAULT_OPTS .. ' ' .. s:evaluate_opts(get(a:dict, 'options', ''))
  if opts =~ 'preview'
    return size
  endif
  let margin = match(opts, '--inline-info\|--info[^-]\{-}inline') > match(opts, '--no-inline-info\|--info[^-]\{-}\(default\|hidden\)') ? 1 : 2
  let margin += match(opts, '--border\([^-]\|$\)') > match(opts, '--no-border\([^-]\|$\)') ? 2 : 0
  if stridx(opts, '--header') > stridx(opts, '--no-header')
    let margin += len(split(opts, "\n"))
  endif
  return srcsz >= 0 ? min([srcsz + margin, size]) : size
endfunction

function! s:getpos()
  return {'tab': tabpagenr(), 'win': winnr(), 'winid': win_getid(), 'cnt': winnr('$'), 'tcnt': tabpagenr('$')}
endfunction

function! s:border_opt(window)
  if type(a:window) != type({})
    return ''
  endif

  " Border style
  let style = tolower(get(a:window, 'border', ''))
  if !has_key(a:window, 'border') && has_key(a:window, 'rounded')
    let style = a:window.rounded ? 'rounded' : 'sharp'
  endif
  if style == 'none' || style == 'no'
    return ''
  endif

  " For --border styles, we need fzf 0.24.0 or above
  call fzf#exec('0.24.0')
  let opt = ' --border ' .. style
  if has_key(a:window, 'highlight')
    let color = s:get_color('fg', a:window.highlight)
    if len(color)
      let opt ..= ' --color=border:' .. color
    endif
  endif
  return opt
endfunction

function! s:split(dict)
  let directions = {
  \ 'up':    ['topleft', 'resize', &lines],
  \ 'down':  ['botright', 'resize', &lines],
  \ 'left':  ['vertical topleft', 'vertical resize', &columns],
  \ 'right': ['vertical botright', 'vertical resize', &columns] }
  let ppos = s:getpos()
  let is_popup = 0
  try
    if s:present(a:dict, 'window')
      if type(a:dict.window) == type({})
        call s:popup(a:dict.window)
        let is_popup = 1
      else
        execute 'keepalt' a:dict.window
      endif
    elseif !s:splittable(a:dict)
      execute $'{tabpagenr()-1}tabnew'
    else
      for [dir, triple] in items(directions)
        let val = get(a:dict, dir, '')
        if !empty(val)
          let [cmd, resz, max] = triple
          if (dir == 'up' || dir == 'down') && val[0] == '~'
            let sz = s:calc_size(max, val, a:dict)
          else
            let sz = s:calc_size(max, val, {})
          endif
          execute $'{cmd} {sz}new'
          execute resz sz
          return [ppos, {}, is_popup]
        endif
      endfor
    endif
    return [ppos, is_popup ? {} : { '&l:wfw': &l:wfw, '&l:wfh': &l:wfh }, is_popup]
  finally
    if !is_popup
      setlocal winfixwidth winfixheight
    endif
  endtry
endfunction

nnoremap <silent> <Plug>(fzf-insert) i
nnoremap <silent> <Plug>(fzf-normal) <Nop>
if exists(':tnoremap')
  tnoremap <silent> <Plug>(fzf-insert) <C-\><C-n>i
  tnoremap <silent> <Plug>(fzf-normal) <C-\><C-n>
endif

let s:warned = 0
function! s:handle_ambidouble(dict)
  if &ambiwidth == 'double'
    let a:dict.env = { 'RUNEWIDTH_EASTASIAN': '1' }
  elseif !s:warned && $RUNEWIDTH_EASTASIAN == '1' && &ambiwidth !=# 'double'
    call s:warn("$RUNEWIDTH_EASTASIAN is '1' but &ambiwidth is not 'double'")
    2sleep
    let s:warned = 1
  endif
endfunction

function! s:execute_term(dict, command, temps) abort
  let winrest = winrestcmd()
  let pbuf = bufnr('')
  let [ppos, winopts, is_popup] = s:split(a:dict)
  call s:use_sh()
  let b:fzf = a:dict
  let fzf = { 'buf': bufnr(''), 'pbuf': pbuf, 'ppos': ppos, 'dict': a:dict, 'temps': a:temps,
            \ 'winopts': winopts, 'winrest': winrest, 'lines': &lines,
            \ 'columns': &columns, 'command': a:command }
  function! fzf.switch_back(inplace)
    if a:inplace && bufnr('') == self.buf
      if bufexists(self.pbuf)
        execute 'keepalt keepjumps b' self.pbuf
      endif
      " No other listed buffer
      if bufnr('') == self.buf
        enew
      endif
    endif
  endfunction
  function! fzf.on_exit(id, code, ...)
    if s:getpos() == self.ppos " {'window': 'enew'}
      for [opt, val] in items(self.winopts)
        execute $'let {opt} = {val}'
      endfor
      call self.switch_back(1)
    else
      if bufnr('') == self.buf
        " We use close instead of bd! since Vim does not close the split when
        " there's no other listed buffer (nvim +'set nobuflisted')
        close
      endif
      silent! execute $'tabnext {self.ppos.tab}'
      silent! execute $'{self.ppos.win}wincmd w'
    endif

    if bufexists(self.buf)
      execute $'bd! {self.buf}'
    endif

    if &lines == self.lines && &columns == self.columns && s:getpos() == self.ppos
      execute self.winrest
    endif

    let lines = s:collect(self.temps)
    if !s:exit_handler(a:code, self.command, 1)
      return
    endif

    call s:pushd(self.dict)
    call s:callback(self.dict, lines)
    call self.switch_back(s:getpos() == self.ppos)

    if &buftype == 'terminal'
      call feedkeys(&filetype == 'fzf' ? "\<Plug>(fzf-insert)" : "\<Plug>(fzf-normal)")
    endif
  endfunction

  try
    call s:pushd(a:dict)
    let command = a:command .. s:term_marker
    let term_opts = {'exit_cb': function(fzf.on_exit)}
    let term_opts.term_kill = 'term'
    if is_popup
      let term_opts.hidden = 1
    else
      let term_opts.curwin = 1
    endif
    call s:handle_ambidouble(term_opts)
    let fzf.buf = term_start([&shell, &shellcmdflag, command], term_opts)
    if is_popup && exists('#TerminalWinOpen')
      doautocmd <nomodeline> TerminalWinOpen
    endif
    tnoremap <buffer> <c-z> <nop>
    if empty(&termwinkey) || &termwinkey =~? '<c-w>'
      tnoremap <buffer> <c-w> <c-w>.
    endif
  finally
    call s:dopopd()
  endtry
  setlocal nospell bufhidden=wipe nobuflisted nonumber
  setfiletype fzf
  startinsert
  return []
endfunction

function! s:collect(temps) abort
  try
    return filereadable(a:temps.result) ? readfile(a:temps.result) : []
  finally
    for tf in values(a:temps)
      silent! call delete(tf)
    endfor
  endtry
endfunction

function! s:callback(dict, lines) abort
  let popd = has_key(a:dict, 'pushd')
  if popd
    let w:fzf_pushd = a:dict.pushd
  endif

  try
    if has_key(a:dict, 'sink')
      for line in a:lines
        if type(a:dict.sink) == 2
          call a:dict.sink(line)
        else
          execute a:dict.sink fnameescape(line)
        endif
      endfor
    endif
    if has_key(a:dict, 'sink*')
      call a:dict['sink*'](a:lines)
    elseif has_key(a:dict, 'sinklist')
      call a:dict['sinklist'](a:lines)
    endif
  catch
    if stridx(v:exception, ':E325:') < 0
      echoerr v:exception
    endif
  endtry

  " We may have opened a new window or tab
  if popd
    let w:fzf_pushd = a:dict.pushd
    call s:dopopd()
  endif
endfunction

function! s:create_popup(opts) abort
  let s:popup_create = {buf -> popup_create(buf, #{
        \ line: a:opts.row,
        \ col: a:opts.col,
        \ minwidth: a:opts.width,
        \ maxwidth: a:opts.width,
        \ minheight: a:opts.height,
        \ maxheight: a:opts.height,
        \ zindex: 1000,
        \ })}
  autocmd TerminalOpen * ++once call s:popup_create(str2nr(expand('<abuf>')))
endfunction

function! s:popup(opts) abort
  let xoffset = get(a:opts, 'xoffset', 0.5)
  let yoffset = get(a:opts, 'yoffset', 0.5)
  let relative = get(a:opts, 'relative', 0)

  " Use current window size for positioning relatively positioned popups
  let columns = relative ? winwidth(0) : &columns
  let lines = relative ? winheight(0) : &lines

  " Size and position
  let width = min([max([8, a:opts.width > 1 ? a:opts.width : float2nr(columns * a:opts.width)]), columns])
  let height = min([max([4, a:opts.height > 1 ? a:opts.height : float2nr(lines * a:opts.height)]), lines])
  let row = float2nr(yoffset * (lines - height)) + (relative ? win_screenpos(0)[0] - 1 : 0)
  let col = float2nr(xoffset * (columns - width)) + (relative ? win_screenpos(0)[1] - 1 : 0)

  " Managing the differences
  let row = min([max([0, row]), &lines - height]) + 1
  let col = min([max([0, col]), &columns - width]) + 1

  call s:create_popup({
    \ 'row': row, 'col': col, 'width': width, 'height': height
  \ })
endfunction

let s:default_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

function! s:shortpath()
  let short = pathshorten(fnamemodify(getcwd(), ':~:.'))
  let slash = '/'
  return empty(short) ? $'~{slash}' : short .. (short =~ $'{escape(slash, "\")}$' ? '' : slash)
endfunction

function! s:cmd(bang, ...) abort
  let args = copy(a:000)
  let opts = { 'options': ['--multi'] }
  if len(args) && isdirectory(expand(args[-1]))
    let opts.dir = substitute(substitute(remove(args, -1), '\\\(["'']\)', '\1', 'g'), '[/\\]*$', '/', '')
    let prompt = opts.dir
  else
    let prompt = s:shortpath()
  endif
  let prompt = strwidth(prompt) < &columns - 20 ? prompt : '> '
  call extend(opts.options, ['--prompt', prompt])
  call extend(opts.options, args)
  call fzf#run(fzf#wrap('FZF', opts, a:bang))
endfunction

command! -nargs=* -complete=dir -bang FZF call s:cmd(<bang>0, <f-args>)

let &cpo = s:cpo_save
unlet s:cpo_save
