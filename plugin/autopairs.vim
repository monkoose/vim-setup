vim9script

g:autopairs_loaded = 1
if exists('g:autopairs_loaded')
  finish
endif
g:autopairs_loaded = 1

g:autopairs = get(g:, 'autopairs', {
  '(': ')',
  '[': ']',
  '{': '}',
  "'": "'",
  '"': '"',
  "`": "`",
})

g:autopairs_map_bs = get(g:, 'autopairs_map_bs', true)
g:autopairs_map_ch = get(g:, 'autopairs_map_ch', true)
g:autopairs_map_cr = get(g:, 'autopairs_map_cr', true)
g:autopairs_map_space = get(g:, 'autopairs_map_space', true)

g:autopairs_wild_close_pair = get(g:, 'autopairs_wild_close_pair', '')

g:autopairs_key_toggle = get(g:, 'autopairs_key_toggle', '<M-p>')
g:autopairs_key_fastwrap = get(g:, 'autopairs_key_fastwrap', '<M-e>')
g:autopairs_key_jump = get(g:, 'autopairs_key_jump', '<M-n>')
# Work with Fly Mode, insert pair where jumped
g:autopairs_key_backinsert = get(g:, 'autopairs_key_backinsert', '<M-b>')

g:autopairs_move_char = get(g:, 'autopairs_move_char', "()[]{}\"'")

# Fly mode will for closed pair to jump to closed pair instead of insert.
# also support autopairs_back_insert to insert pairs where jumped.
g:autopairs_flymode = get(g:, 'autopairs_flymode', true)

# When skipping the closed pair, look at the current and next line as well.
g:autopairs_multiline_close = get(g:, 'autopairs_multiline_close', true)

g:autopairs_smart_quotes = get(g:, 'autopairs_smart_quotes', true)

const left_key = "\<C-g>U\<Left>"
const right_key = "\<C-g>U\<Right>"

var autopairs_saved_pair: list<any>

def Left(str: string): string
  return repeat(left_key, strwidth(str))
enddef

def Right(str: string): string
  return repeat(right_key, strwidth(str))
enddef

def Delete(str: string): string
  return repeat("\<Del>", strwidth(str))
enddef

def Backspace(str: string): string
  return repeat("\<BS>", strwidth(str))
enddef

# default pairs base on filetype
def AutoPairsDefaultPairs(): dict<string>
  if exists('b:autopairs_defaultpairs')
    return b:autopairs_defaultpairs
  endif

  final result = copy(g:autopairs)
  const all_pairs = {
    # vim: {'^\s*\zs"': ''},
    rust: {'\w\zs<': '>', '&\zs''': ''},
    php: {'<?': '?>//k]', '<?php': '?>//k]'}
  }

  for [filetype, pairs] in items(all_pairs)
    if &filetype == filetype
      extend(result, pairs)
    endif
  endfor
  b:autopairs_defaultpairs = result
  return result
enddef

def GetLine(): list<string>
  var line: string = getline('.')
  const pos: number = col('.') - 1
  const before: string = strpart(line, 0, pos)
  var after: string = strpart(line, pos)
  const afterline: string = after

  if g:autopairs_multiline_close
    const last_lnum: number = line('$')
    var i: number = line('.') + 1
    while i <= last_lnum
      line = getline(i)
      after = $'{after} {line}'
      if !(line =~ '^\s*$')
        break
      endif
      ++i
    endwhile
  endif

  return [before, after, afterline]
enddef

def Matchend(text: string, open: string): list<string>
  const match = matchstr(text, $'\V{open}\$')
  if empty(match)
    return []
  endif

  const text_before_open = strpart(text, 0, len(text) - len(match))
  return [text_before_open, match]
enddef

def Matchbegin(text: string, close: string): list<string>
    const match = matchstr(text, $'^\V{close}')
    if empty(match)
      return []
    endif

    const text_after_close = strpart(text, len(text) - len(match))
    return [match, text_after_close]
enddef

# add or delete pairs based on g:autopairs
# eg:
#   autocmd FileType html let b:autopairs = AutoPairsDefine({'<!--' : '-->'}, ['{'])
#   will add <!-- --> pair and remove '{}' for html filetype
export def AutoPairsDefine(add_pairs: dict<string>, remove_open: list<string> = []): dict<string>
  final result = AutoPairsDefaultPairs()

  # remove from resulted dict
  map(remove_open, (_, open) => remove(result, open))

  # add to resulted dict
  extend(result, add_pairs)

  return result
enddef

def AutoPairsInsert(key: string)
  if !b:autopairs_enabled
    feedkeys(key, 'n')
    return
  endif

  autopairs_saved_pair = [key, getpos('.')]

  var [before, after, afterline] = GetLine()

  # Ignore auto close if prev character is \
  if before[-1 : -1] == '\'
    feedkeys(key, 'n')
    return
  endif

  var ms: list<string>
  var m: string
  # check open pairs
  for [open, close, opt] in b:autopairs_list
    ms = Matchend(before .. key, open)
    m = matchstr(afterline, $'^\s*\zs\V{close}')
    if !empty(ms)
      # remove inserted pair
      # eg: if the pairs include < > and  <!-- -->
      # when <!-- is detected the inserted pair < > should be clean up
      const target = ms[0]
      const openPair = ms[1]

      if len(openPair) == 1 && m == openPair
        break
      endif

      var bs = ''
      var del = ''
      while len(before) > len(target)
        var found = 0
        # delete pair
        for [o, c, _] in b:autopairs_list
          const os = Matchend(before, o)
          if !empty(os)
            if len(os[0]) < len(target)
              # any text before openPair should not be deleted
              continue
            endif

            const cs = Matchbegin(afterline, c)
            if !empty(cs)
              found = 1
              before = os[0]
              afterline = cs[1]
              bs ..= Backspace(os[1])
              del ..= Delete(cs[0])
              break
            endif
          endif
        endfor

        if !found
          # delete charactor
          ms = Matchend(before, '.')
          if !empty(ms)
            before = ms[0]
            bs ..= Backspace(ms[1])
          endif
        endif
      endwhile
      feedkeys($'{bs}{del}{openPair}{close}{Left(close)}', 'n')
      return
    endif
  endfor

  # check close pairs
  for [open, close, opt] in b:autopairs_list
    if empty(close)
      continue
    endif

    if key == g:autopairs_wild_close_pair || opt.mapclose && opt.key == key
      # the close pair is in the same line
      m = matchstr(afterline, $'^\s*\V{close}')
      if !empty(m)
        if before =~ $'\V{open}\s*$' && m[0] =~ '\s'
          # remove the space we inserted if the text in pairs is blank
          feedkeys("\<DEL>" .. Right(m[1 :]), 'n')
          return
        else
          feedkeys(Right(m), 'n')
          return
        endif
      endif

      m = matchstr(after, $'^\s*\zs\V{close}')
      if !empty(m)
        if key == g:autopairs_wild_close_pair || opt.multiline
          const lnum = line('.')
          if b:autopairs_return_pos == lnum && getline(lnum) =~ '^\s*$'
            normal! ddk$
          endif
          search(m, 'We')
          feedkeys(right_key, 'n')
          return
        else
          break
        endif
      endif
    endif
  endfor

  # Fly Mode, and the key is closed-pairs, search closed-pair and jump
  if g:autopairs_flymode && key =~ '[}\])]'
    if !!search(key, 'We')
      feedkeys(right_key, 'n')
      return
    endif
  endif

  feedkeys(key, 'n')
  return
enddef

def AutoPairsDelete()
  if !b:autopairs_enabled
    feedkeys("\<BS>", 'n')
    return
  endif

  const [before, after, ig] = GetLine()
  var a: string
  var b: string
  for [open, close, opt] in b:autopairs_list
    b = matchstr(before, $'\V{open}\s\?\$')
    a = matchstr(after, $'^\s\?\V{close}')
    if !empty(b) && !empty(a)
      if slice(b, -1) == ' '
        if a[0] == ' '
          feedkeys("\<BS>\<Del>", 'n')
        else
          feedkeys("\<BS>", 'n')
        endif
        return
      endif
      feedkeys(Backspace(b) .. Delete(a), 'n')
      return
    endif
  endfor

  # # delete the pair foo[]| <BS> to foo
  # var m: list<string>
  # for [open, close, opt] in b:autopairs_list
  #   m = Matchend(before, '\V'.open.'\v\s*'.'\V'.close.'\v$')
  #   if !empty(m)
  #     return Backspace(m[1])
  #   endif
  # endfor

  feedkeys("\<BS>", 'n')
  return
enddef

# Fast wrap the word in brackets
def AutoPairsFastWrap()
  const c = getreg('"')
  normal! x
  const [before, after, ig] = GetLine()

  if after[0] =~ '[{\[(<]'
    normal! %
    normal! p
  else
    for [open, close, opt] in b:autopairs_list
      if empty(close)
        continue
      endif
      if after =~ $'^\s*\V{open}'
        search(close, 'We')
        normal! p
        setreg('"', c)
        return
      endif
    endfor

    if after[1 : 1] =~ '\w'
      normal! e
      normal! p
    else
      normal! p
    endif
  endif

  setreg('"', c)
enddef

def AutoPairsJump()
  search('["\]'')}]', 'W')
enddef

def AutoPairsMoveChar(key: string)
  const c = getline('.')[col('.') - 1]
  feedkeys("\<Del>\<Esc>", 'nx')
  search(key, 'W')
  feedkeys($'a{c}{left_key}', 'n')
enddef

def AutoPairsBackInsert()
  setpos('.', autopairs_saved_pair[1])
  feedkeys(autopairs_saved_pair[0], 'nx')
enddef

def AutoPairsReturn(): string
  if !b:autopairs_enabled
    return ''
  endif

  b:autopairs_return_pos = 0
  const before = getline(line('.') - 1)
  const [_, _, afterline] = GetLine()
  const cmd = ''
  for [open, close, opt] in b:autopairs_list
    if empty(close)
      continue
    endif

    if before =~ $'\V{open}\v\s*$' && afterline =~ $'^\s*\V{close}'
      b:autopairs_return_pos = line('.')

      # If equalprg has been set, then avoid call =
      # https://github.com/jiangmiao/auto-pairs/issues/24
      if !empty(&equalprg)
        return $"\<ESC>{cmd}O"
      endif

      # conflict with javascript and coffee
      # javascript   need   indent new line
      # coffeescript forbid indent new line
      if &filetype == 'coffeescript' || &filetype == 'coffee'
        return $"\<ESC>{cmd}k==o"
      else
        return $"\<ESC>{cmd}=ko"
      endif
    endif
  endfor

  return ''
enddef

def AutoPairsSpace()
  if !b:autopairs_enabled
    feedkeys("\<space>", 'n')
    return
  endif

  const [before, after, ig] = GetLine()

  for [open, close, opt] in b:autopairs_list
    if empty(close)
      continue
    endif

    if before =~ $'\V{open}\v$' && after =~ $'^\V{close}'
      if close =~ '^[''"`]$'
        feedkeys("\<space>", 'n')
      else
        feedkeys("\<space>\<space>" .. left_key, 'n')
      endif
      return
    endif
  endfor

  feedkeys("\<space>", 'n')
  return
enddef

def AutoPairsMap(k: string)
  # | is special key which separate map command from text
  const key = k == '|' ? '<BAR>' : k
  const escaped_key = substitute(key, "'", "''", 'g')
  execute $"inoremap <buffer><silent> {key} <ScriptCmd>AutoPairsInsert('{escaped_key}')<CR>"
enddef

def AutoPairsToggle()
  if b:autopairs_enabled
    b:autopairs_enabled = false
    echo 'AutoPairs Disabled.'
  else
    b:autopairs_enabled = true
    echo 'AutoPairs Enabled.'
  endif
enddef

def AutoPairsInit()
  b:autopairs_loaded = true
  b:autopairs_enabled = get(b:, 'autopairs_enabled', true)
  b:autopairs = get(b:, 'autopairs', AutoPairsDefaultPairs())
  b:autopairs_move_char = get(b:, 'autopairs_move_char', g:autopairs_move_char)

  b:autopairs_return_pos = 0
  b:autopairs_list = []

  # buffer level map pairs keys
  # n - do not map the first charactor of closed pair to close key
  # m - close key jumps through multi line
  # s - close key jumps only in the same line
  for [open, close] in items(b:autopairs)
    const o = open[-1 : -1]
    var temp_close = close
    var c = close[0]
    final opt = {mapclose: 1, multiline: o == c ? 0 : 1, key: c}
    const m = matchlist(close, '\v(.*)//(.*)$')

    if !empty(m)
      if m[2] =~ 'n'
        opt.mapclose = 0
      endif
      if m[2] =~ 'm'
        opt.multiline = 1
      endif
      if m[2] =~ 's'
        opt.multiline = 0
      endif
      const ks = matchlist(m[2], 'k.')
      if !empty(ks)
        opt.key = ks[1]
        c = opt.key
      endif
      temp_close = m[1]
    endif

    AutoPairsMap(o)

    if o != c && !empty(c) && opt.mapclose
      AutoPairsMap(c)
    endif
    add(b:autopairs_list, [open, temp_close, opt])
  endfor

  # sort pairs by length, longer pair should have higher priority
  b:autopairs_list = sort(b:autopairs_list, (a, b) => len(a[0]) - len(b[0]))

  for item in b:autopairs_list
    const [open, close, opt] = item
    if item[0] == "'" && item[0] == item[1]
      item[0] = '\v(^|\W)\zs'''
    endif
  endfor

  var escaped_key: string
  for key in split(b:autopairs_move_char, '\s*')
    escaped_key = substitute(key, "'", "''", 'g')
    execute $"inoremap <silent><buffer> <M-{key}> <C-o>:call <SID>AutoPairsMoveChar('{escaped_key}')<CR>"
  endfor

  if g:autopairs_map_bs
    execute 'inoremap <buffer><silent> <BS> <ScriptCmd>AutoPairsDelete()<CR>'
  endif

  if g:autopairs_map_ch
    execute 'inoremap <buffer><silent> <C-h> <ScriptCmd>AutoPairsDelete()<CR>'
  endif

  if g:autopairs_map_space
    execute 'inoremap <buffer><silent> <space> <C-]><ScriptCmd>AutoPairsSpace()<CR>'
  endif

  if !empty(g:autopairs_key_fastwrap)
    execute $'inoremap <buffer><silent> {g:autopairs_key_fastwrap} <ScriptCmd>AutoPairsFastWrap()<CR>'
  endif

  if !empty(g:autopairs_key_backinsert)
    execute $'inoremap <buffer><silent> {g:autopairs_key_backinsert} <ScriptCmd>AutoPairsBackInsert()<CR>'
  endif

  if !empty(g:autopairs_key_toggle)
    execute $'inoremap <buffer><silent> {g:autopairs_key_toggle} <ScriptCmd>AutoPairsToggle()<CR>'
    execute $'nnoremap <buffer><silent> {g:autopairs_key_toggle} <ScriptCmd>AutoPairsToggle()<CR>'
  endif

  if !empty(g:autopairs_key_jump)
    execute $'inoremap <buffer><silent> {g:autopairs_key_jump} <ScriptCmd>AutoPairsJump()<CR>'
    execute $'noremap <buffer><silent> {g:autopairs_key_jump} <ScriptCmd>AutoPairsJump()<CR>'
  endif

  if !empty(&keymap)
    # &l:keymap = &keymap
    # &l:imsearch = &imsearch
    # &l:iminsert = &iminsert
    # &l:imdisable = &imdisable
  endif
enddef

def ExpandMap(m: string): string
  var map = substitute(m, '\(<Plug>\w\+\)', '\=maparg(submatch(1), "i")', 'g')
  map = substitute(map, '\(<Plug>([^)]*)\)', '\=maparg(submatch(1), "i")', 'g')

  return map
enddef

def AutoPairsTryInit()
  if exists('b:autopairs_loaded') | return | endif

  # for auto-pairs starts with 'a', so the priority is higher than supertab and vim-endwise
  #
  # vim-endwise doesn't support <Plug>AutoPairsReturn
  # when use <Plug>AutoPairsReturn will cause <Plug> isn't expanded
  #
  # supertab doesn't support <SID>AutoPairsReturn
  # when use <SID>AutoPairsReturn  will cause Duplicated <CR>
  #
  # and when load after vim-endwise will cause unexpected endwise inserted.
  # so always load AutoPairs at last

  # Buffer level keys mapping
  # comptible with other plugin
  if g:autopairs_map_cr
    const info = maparg('<CR>', 'i', 0, 1)
    var old_cr: string
    var is_expr: bool
    var wrapper_name: string = ''
    if empty(info)
      old_cr = '<CR>'
      is_expr = false
    else
      old_cr = info.rhs->ExpandMap()->substitute('<SID>', '<SNR>{info.sid}_', 'g')
      is_expr = info.expr
      wrapper_name = '<SID>AutoPairsOldCRWrapper73'
    endif

    if old_cr !~ 'AutoPairsReturn'
      if is_expr
        # remap <expr> to `name` to avoid mix expr and non-expr mode
        execute $'inoremap <buffer><expr><script> {wrapper_name} {old_cr}'
        old_cr = wrapper_name
      endif
      # Always silent mapping
      execute $'inoremap <script><buffer><silent> <CR> {old_cr}<SID>AutoPairsReturn'
    endif
  endif
  AutoPairsInit()
enddef

# Always silent the command
inoremap <silent> <SID>AutoPairsReturn <C-R>=AutoPairsReturn()<CR>
imap <script> <Plug>AutoPairsReturn <SID>AutoPairsReturn

augroup AutoPairs
  autocmd!
  autocmd BufEnter * AutoPairsTryInit()
augroup END

defcompile
