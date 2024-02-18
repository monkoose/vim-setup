vim9script

setlocal shiftwidth=2

call custom#undo_ftplugin#Set('setl sw<')

def InsideTag(tagname: string): bool
  const open_tag = '<' .. tagname .. '\>'
  const close_tag = '</' .. tagname .. '>'

  if searchpair(open_tag, '', close_tag, 'nW') > 0
    if match(getline('.'), '^\s*' .. open_tag) == -1
      return true
    endif
  endif

  return false
enddef

def SetCommentString()
  if InsideTag('script')
    &l:commentstring = '//%s'
  elseif InsideTag('style')
    &l:commentstring = '/*%s*/'
  else
    &l:commentstring = '<!--%s-->'
  endif
enddef

xmap <buffer> gc  <ScriptCmd>SetCommentString()<CR><Plug>Commentary
nmap <buffer> gc  <ScriptCmd>SetCommentString()<CR><Plug>Commentary
omap <buffer> gc  <ScriptCmd>SetCommentString()<CR><Plug>Commentary
nmap <buffer> gcc <ScriptCmd>SetCommentString()<CR><Plug>CommentaryLine
nmap <buffer> gcu <ScriptCmd>SetCommentString()<CR><Plug>Commentary<Plug>Commentary
