vim9script noclear

# Exit quickly when:
# - this plugin was already loaded (or disabled)
# - 'compatible' is set
# - there are no colors (looks like the cursor jumps)
if exists('g:loaded_matchparen')
    || &compatible
    || &t_Co->str2nr() < 8 && !has('gui_running')
  finish
endif
g:loaded_matchparen = 1

# Configuration {{{1

var config: dict<any> = {
  compatible: true,
  on_startup: true,
  syntax_ignored: false,
  # Need to inspect g:matchparen_timeout to be backward compatible.
  timeout: get(g:, 'matchparen_timeout', 300),
  timeout_insert: get(g:, 'matchparen_insert_timeout', 60),
}

extend(config, get(g:, 'matchparen_config', {}))

if empty(prop_type_get('matchparen'))
  prop_type_add('matchparen', {highlight: 'MatchParen'})
endif

# Commands {{{1

# Define command that will disable and enable the plugin.
command -bar -complete=custom,Complete -nargs=? MatchParen Toggle(<q-args>)

# Need to install these commands to be backward compatible.
if config.compatible
  command -bar DoMatchParen MatchParen on
  command -bar NoMatchParen MatchParen off
endif

# Autocommands {{{1

# Wrap the autocommands inside a function so that they can be easily installed
# or removed on-demand later.
def Autocmds(enable: bool)
  if enable && !exists('#matchparen')
    augroup matchparen
      autocmd!
      # FileType because 'matchpairs' could be (re)set by a filetype plugin
      autocmd WinEnter,BufWinEnter,FileType,VimEnter * ParseMatchpairs()
      autocmd OptionSet matchpairs ParseMatchpairs()

      autocmd CursorMoved,CursorMovedI,WinEnter,WinScrolled * UpdateHighlight()
      autocmd InsertEnter * UpdateHighlight(true)
      autocmd TextChanged,TextChangedI * UpdateHighlight()
      # In case we reload the buffer while the cursor is on a paren.
      # Need to delay with SafeState because when reloading, the cursor is
      # temporarily on line 1 col 1, no matter its position before the reload.
      autocmd BufReadPost * autocmd SafeState <buffer=abuf> ++once UpdateHighlight()

      # BufLeave is necessary when the cursor is on a parenthesis and we open
      # the quickfix window.
      autocmd WinLeave,BufLeave * RemoveHighlight()
    augroup END

  elseif !enable && exists('#matchparen')
    autocmd! matchparen
    augroup! matchparen
  endif
enddef

if config.on_startup
  Autocmds(true)
endif

# Variable Declarations {{{1
var before: number
var c_lnum: number
var c_col: number
var m_lnum: number
var m_col: number
var matchpairs: string
var pairs: dict<list<string>>

# Functions {{{1
def Complete(_, _, _): string  #{{{2
  return ['on', 'off', 'toggle']->join("\n")
enddef

def IsInsertMode(): bool  #{{{2
  const mode = mode()
  return mode == 'i' || mode == 'R'
enddef

def ParseMatchpairs()  #{{{2
  if matchpairs == &matchpairs
    return
  endif
  matchpairs = &matchpairs
  pairs = {}
  for [opening: string, closing: string] in
      matchpairs
        ->split(',')
        ->map((_, v: string): list<string> => split(v, ':'))
    pairs[opening] = [escape(opening, '[]'), escape(closing, '[]'),  'nW', 'w$']
    pairs[closing] = [escape(opening, '[]'), escape(closing, '[]'), 'bnW', 'w0']
  endfor
enddef

def UpdateHighlight(insert_enter: bool = false)  #{{{2
# The function that is invoked (very often) to define a highlighting for any
# matching paren.

  RemoveHighlight()

  # Avoid that we remove the popup menu
  if pumvisible()
      # Nothing to highlight if we're in a closed fold
      || foldclosed('.') != -1
    return
  endif

  # Save cursor position so it can be used later
  const saved_cursor = getcurpos()
  # Get the character under the cursor and check if it's in 'matchpairs'
  [_, c_lnum, c_col; _] = saved_cursor
  const text = getline(c_lnum)
  const charcol = charcol('.')
  const in_insert_mode = insert_enter || IsInsertMode()
  var c = text[charcol - 1]
  before = 0
  # In Insert mode try character before the cursor
  if in_insert_mode
    const c_before = charcol == 1 ? '' : text[charcol - 2]
    if has_key(pairs, c_before)
      if c_col > 1
        before = strlen(c_before)
        c = c_before
      endif
    else
      # Still not on matching bracket
      if !has_key(pairs, c)
        return
      endif
    endif
  else
    if !has_key(pairs, c)
      return
    endif
  endif

  # Figure out the arguments for searchpairpos()
  # Use a stopline to limit the search to lines visible in the window
  var c2: string
  var s_flags: string
  var stopline: string
  [c, c2, s_flags, stopline] = pairs[c]

  # Find the match.
  # When it was just before the cursor, move the latter there for a moment.
  if before > 0
    cursor(c_lnum, c_col - before)
  endif

  var Skip: func: bool
  try
    Skip = GetSkip()
  # synstack() inside InStringOrComment() might throw:
  # E363: pattern uses more memory than 'maxmempattern'.
  catch /^Vim\%((\a\+)\)\=:E363:/
    # We won't find anything, so skip searching to keep Vim responsive.
    return
  endtry

  # Limit the search time to avoid a hang on very long lines.
  var timeout: number
  if in_insert_mode
    timeout = GetOption('timeout_insert')
  else
    timeout = GetOption('timeout')
  endif
  try
    [m_lnum, m_col] = searchpairpos(c, '', c2, s_flags, Skip, line(stopline), timeout)
  catch /^Vim\%((\a\+)\)\=:E363:/
  endtry

  if before > 0
    setpos('.', saved_cursor)
  endif

  if m_lnum > 0
    Highlight()
  endif
enddef

def RemoveHighlight()  #{{{2
  # `:silent!` to suppress E16 in case `line('w$')` is 0
  silent! prop_remove({type: 'matchparen', all: true}, line('w0'), line('w$'))
enddef


def Highlight()  #{{{2
  var props: dict<any> = {length: 1, type: 'matchparen'}
  prop_add(c_lnum, c_col - before, props)
  prop_add(m_lnum, m_col, props)
enddef

def Toggle(args: string)  #{{{2
  if args == ''
    var usage: list<string> =<< trim END
      # to enable the plugin
      :MatchParen on

      # to disable the plugin
      :MatchParen off

      # to toggle the plugin
      :MatchParen toggle
    END
    echo usage->join("\n")
    return
  endif

  if ['on', 'off', 'toggle']->index(args) == -1
    redraw
    echohl ErrorMsg
    echomsg 'matchparen: invalid argument'
    echohl NONE
    return
  endif

  def Enable()
    Autocmds(true)
    ParseMatchpairs()
    UpdateHighlight()
  enddef

  def Disable()
    Autocmds(false)
    RemoveHighlight()
  enddef

  if args == 'on'
    Enable()
  elseif args == 'off'
    Disable()
  elseif args == 'toggle'
    if !exists('#matchparen')
      Enable()
    else
      Disable()
    endif
  endif
enddef

def InStringOrComment(): bool  #{{{2
# Should return true when the current cursor position is in certain syntax types
# (string, comment,  etc.); evaluated inside  lambda passed as skip  argument to
# searchpairpos().

  # can improve the performance when inserting characters in front of a paren
  # while there are closed folds in the buffer
  if foldclosed('.') != -1
    return false
  endif

  # After moving to the end of a line  with `$`, then onto the  line below with
  # `k`, `synstack()` might wrongly give an empty stack.  Possible bug:
  # https://github.com/vim/vim/issues/5252
  var synstack: list<number> = synstack('.', col('.'))
  if empty(synstack) && getcurpos()[-1] == v:maxcol
    # As a workaround, we ask for the syntax a second time.
    synstack = synstack('.', col('.'))
  endif

  for synID: number in synstack
    # We match `escape` and `symbol` for special items, such as
    # `lispEscapeSpecial` or `lispBarSymbol`.
    if synIDattr(synID, 'name') =~? 'string\|character\|singlequote\|escape\|symbol\|comment'
      return true
    endif
  endfor
  return false
enddef

def GetSkip(): func(): bool  #{{{2
  if !exists('b:current_syntax') || GetOption('syntax_ignored')
    return (): bool => false
  else
    # If evaluating the expression determines that the cursor is
    # currently in a text with some specific syntax type (like a string
    # or a comment), then we want searchpairpos() to find a pair within
    # a text of similar type; i.e. we want to ignore a pair of different
    # syntax type.
    if InStringOrComment()
      return (): bool => !InStringOrComment()
    # Otherwise, the cursor is outside of these specific syntax types,
    # and we want searchpairpos() to find a pair which is also outside.
    else
      return (): bool => InStringOrComment()
    endif
  endif
enddef

def GetOption(name: string): any  #{{{2
  var value: number = -1
  # Special  cases needed  to be  backward compatible  and support  old variable
  # names.
  if name == 'timeout'
    value = get(b:, 'matchparen_timeout', -1)
  elseif name == 'timeout_insert'
    value = get(b:, 'matchparen_insert_timeout', -1)
  endif

  if value != -1
    return value
  else
    return get(b:, 'matchparen_config', {})
            ->get(name, config[name])
  endif
enddef

# vim: fdm=marker
