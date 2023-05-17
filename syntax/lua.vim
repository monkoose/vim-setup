" Vim syntax file
" Language: Lua

if exists("b:current_syntax")
  finish
endif

let main_syntax = 'lua'

syntax sync minlines=100

" Symbols
syntax match  luaComma ","
syntax match  luaSemiColon ";"
syntax match  luaSymbolOperator "[#<>=~^&|*/%+-]\|\.\."
syntax match  luaEllipsis "\.\.\."

" Comments
" Shebang at the start
syntax match   luaComment "\%^#!.*"

syntax keyword luaCommentTodo contained TODO FIXME XXX
syntax match   luaComment "--.*$" contains=luaCommentTodo,luaDocTag,@Spell display
syntax region  luaCommentLong matchgroup=luaCommentLongTag start="--\[\z(=*\)\[" end="\]\z1\]" contains=luaCommentTodo,luaDocTag,@Spell
syntax match   luaDocTag contained "\s\zs@\k\+"

" goto and labels
syntax keyword luaGoto goto nextgroup=luaGotoLabel skipwhite
syntax match luaGotoLabel "\k\+" contained display
syntax match luaLabel "::\k\+::" display

syntax keyword luaFunction function nextgroup=luaFuncFullName skipwhite
syntax match luaFuncName "\k\+\ze\s\?(" contained
syntax match luaFuncFullName "\(\k\+[:.]\)\?\k\+\s\?(" display contained contains=luaFuncName

" Keywords
syntax keyword luaBlock do end
syntax keyword luaRepeat repeat until while for in
syntax keyword luaCond if elseif else then
syntax keyword luaConstant nil true false
syntax keyword luaBuiltIn _ENV self
syntax keyword luaLocal local
syntax keyword luaOperator and or not
syntax keyword luaStatement break return

" Strings
syntax match  luaStringSpecial contained #\\[\\abfnrtvz'"]\|\\x[[:xdigit:]]\{2}\|\\[[:digit:]]\{,3}#
syntax region luaStringLong matchgroup=luaStringLongTag start="\[\z(=*\)\[" end="\]\z1\]" contains=@Spell
syntax region luaString  start=+'+ end=+'+ skip=+\\\\\|\\'+ contains=luaStringSpecial,@Spell
syntax region luaString  start=+"+ end=+"+ skip=+\\\\\|\\"+ contains=luaStringSpecial,@Spell

" hexadecimal constant
syntax match luaNumber "\c\<0x\%([0-9a-f]\+\%(\.[0-9a-f]*\)\?\|[0-9a-f]*\.[0-9a-f]\+\)\%(p[-+]\?\d\+\)\?\>" display
" decimal constants
syntax match luaNumber "\<\%(\d\+\%(\.\d*\)\?\|\d*\.\d\+\)\%([eE][-+]\?\d\+\)\?\>" display

syntax keyword luaRequire
      \ module
      \ require

syntax keyword luaErrHand
      \ assert
      \ error
      \ pcall
      \ xpcall

syntax keyword luaGlobalTable _G

hi def link luaBuiltIn          Special
hi def link luaComment          Comment
hi def link luaCommentLongTag   luaCommentLong
hi def link luaCommentLong      luaComment
hi def link luaCommentTodo      Todo
hi def link luaConstant         Constant
hi def link luaDocTag           Underlined
hi def link luaEllipsis         Special
hi def link luaGotoLabel        Identifier
hi def link luaLabel            uaGotoLabel
hi def link luaLocal            Type
hi def link luaNumber           Number
hi def link luaSymbolOperator   luaOperator
hi def link luaOperator         Operator
hi def link luaCond             Conditional
hi def link luaRepeat           Repeat
hi def link luaBlock            luaRepeat
hi def link luaFunction         Statement
hi def link luaFuncName         Function
hi def link luaRequire          Include
hi def link luaComma            Delimiter
hi def link luaSemiColon        luaComma
hi def link luaGlobalTable      Identifier
hi def link luaStatement        Statement
hi def link luaGoto             Statement
hi def link luaString           String
hi def link luaStringLong       luaString
hi def link luaStringSpecial    SpecialChar
hi def link luaErrHand          Exception

let b:current_syntax = "lua"
if main_syntax == 'lua'
  unlet main_syntax
endif
