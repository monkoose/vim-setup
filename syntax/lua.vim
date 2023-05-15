" Vim syntax file
" Language: Lua

if exists("b:current_syntax")
  finish
endif

let main_syntax = 'lua'

syntax sync minlines=100

" Clusters
syntax cluster luaBase contains=luaComment,luaCommentLong,luaConstant,luaNumber,luaString,luaStringLong,luaBuiltIn
syntax cluster luaExpr contains=@luaBase,luaTable,luaParen,luaBracket,luaSpecialTable,luaSpecialValue,luaRequire,luaOperator,luaSymbolOperator,luaEllipsis,luaComma,luaFunc,luaFuncCall
syntax cluster luaStat contains=@luaExpr,luaIfThen,luaBlock,luaLoop,luaGoto,luaLabel,luaLocal,luaStatement,luaSemiColon,luaErrHand

syntax match luaNoise /\%(\.\|,\|:\|\;\)/

" Symbols
syntax region luaTable transparent matchgroup=luaBraces start="{" end="}" contains=@luaExpr
syntax region luaParen   transparent matchgroup=luaParens   start='(' end=')' contains=@luaExpr
syntax region luaBracket transparent matchgroup=luaBrackets start="\[" end="\]" contains=@luaExpr
syntax match  luaComma ","
syntax match  luaSemiColon ";"

if !exists('g:lua_syntax_nosymboloperator')
  syntax match luaSymbolOperator "[#<>=~^&|*/%+-]\|\.\."
endi

syntax match  luaEllipsis "\.\.\."

" Shebang at the start
syntax match luaComment "\%^#!.*"

" Comments
syntax keyword luaCommentTodo contained TODO FIXME XXX
syntax match   luaComment "--.*$" contains=luaCommentTodo,luaDocTag,@Spell
syntax region luaCommentLong matchgroup=luaCommentLongTag start="--\[\z(=*\)\[" end="\]\z1\]" contains=luaCommentTodo,luaDocTag,@Spell
syntax match   luaDocTag contained "\s\zs@\k\+"

" Function calls
syntax match luaFuncCall /\k\+\%(\s*[{('"]\)\@=/

" Functions
syntax region luaFunc transparent matchgroup=luaFuncKeyword start="\<function\>" end="\<end\>" contains=@luaStat,luaFuncSig
syntax region luaFuncSig contained transparent start="\(\<function\>\)\@<=" end=")" contains=luaFuncId,luaFuncArgs keepend
syntax match luaFuncId contained "[^(]*(\@=" contains=luaFuncTable,luaFuncName
syntax match luaFuncTable contained /\k\+\%(\s*[.:]\)\@=/
syntax match luaFuncName contained "[^(.:]*(\@="
syntax region luaFuncArgs contained transparent matchgroup=luaFuncParens start=/(/ end=/)/ contains=@luaBase,luaFuncArgName,luaFuncArgComma,luaEllipsis
syntax match luaFuncArgName contained /\k\+/
syntax match luaFuncArgComma contained /,/

" if ... then
syntax region luaIfThen transparent matchgroup=luaCond start="\<if\>" end="\<then\>"me=e-4 contains=@luaExpr nextgroup=luaThenEnd skipwhite skipempty

" then ... end
syntax region luaThenEnd contained transparent matchgroup=luaCond start="\<then\>" end="\<end\>" contains=@luaStat,luaElseifThen,luaElse

" elseif ... then
syntax region luaElseifThen contained transparent matchgroup=luaCond start="\<elseif\>" end="\<then\>" contains=@luaExpr

" else
syntax keyword luaElse contained else

" do ... end
syntax region luaLoopBlock transparent matchgroup=luaRepeat start="\<do\>" end="\<end\>" contains=@luaStat contained
syntax region luaBlock transparent matchgroup=luaStatement start="\<do\>" end="\<end\>" contains=@luaStat

" repeat ... until
syntax region luaLoop transparent matchgroup=luaRepeat start="\<repeat\>" end="\<until\>" contains=@luaStat nextgroup=@luaExpr

" while ... do
syntax region luaLoop transparent matchgroup=luaRepeat start="\<while\>" end="\<do\>"me=e-2 contains=@luaExpr nextgroup=luaLoopBlock skipwhite skipempty

" for ... do and for ... in ... do
syntax region luaLoop transparent matchgroup=luaRepeat start="\<for\>" end="\<do\>"me=e-2 contains=@luaExpr,luaIn nextgroup=luaLoopBlock skipwhite skipempty
syntax keyword luaIn contained in

" goto and labels
syntax keyword luaGoto goto nextgroup=luaGotoLabel skipwhite
syntax match luaGotoLabel "\k\+" contained
syntax match luaLabel "::\k\+::"

" Other Keywords
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
syntax match luaNumber "\c\<0x\%([0-9a-f]\+\%(\.[0-9a-f]*\)\?\|[0-9a-f]*\.[0-9a-f]\+\)\%(p[-+]\?\d\+\)\?\>"
" decimal constants
syntax match luaNumber "\<\%(\d\+\%(\.\d*\)\?\|\d*\.\d\+\)\%([eE][-+]\?\d\+\)\?\>"

syntax keyword luaRequire
      \ module
      \ require

syntax keyword luaErrHand
      \ assert
      \ error
      \ pcall
      \ xpcall

  syntax keyword luaSpecialTable
        \ _G
        \ bit32
        \ coroutine
        \ debug
        \ io
        \ math
        \ os
        \ package
        \ string
        \ table
        \ utf8

if exists('g:lua_syntax_enable_stdfunc')
  syntax keyword luaSpecialValue
        \ _VERSION
        \ collectgarbage
        \ dofile
        \ getfenv
        \ getmetatable
        \ ipairs
        \ load
        \ loadfile
        \ loadstring
        \ next
        \ pairs
        \ print
        \ rawequal
        \ rawget
        \ rawlen
        \ rawset
        \ select
        \ setfenv
        \ setmetatable
        \ tonumber
        \ tostring
        \ type
        \ unpack
endif

hi def link luaParens           Noise
hi def link luaBraces           Structure
hi def link luaBrackets         Noise
hi def link luaBuiltIn          Special
hi def link luaComment          Comment
hi def link luaCommentLongTag   luaCommentLong
hi def link luaCommentLong      luaComment
hi def link luaCommentTodo      Todo
hi def link luaCond             Conditional
hi def link luaConstant         Constant
hi def link luaDocTag           Underlined
hi def link luaEllipsis         Special
hi def link luaElse             Conditional
hi def link luaFuncArgName      Noise
hi def link luaFuncCall         Function
hi def link luaFuncId           Function
hi def link luaFuncName         luaFuncId
hi def link luaFuncTable        Constant
hi def link luaFunction         Structure
hi def link luaFuncKeyword      luaFunction
hi def link luaFuncParens       Noise
hi def link luaGoto             luaStatement
hi def link luaGotoLabel        Noise
hi def link luaIn               Repeat
hi def link luaLabel            Label
hi def link luaLocal            Type
hi def link luaNumber           Number
hi def link luaSymbolOperator   luaOperator
hi def link luaOperator         Operator
hi def link luaRepeat           Repeat
hi def link luaRequire          Include
hi def link luaComma            Delimiter
hi def link luaSemiColon        Delimiter
hi def link luaSpecialTable     Identifier
hi def link luaSpecialValue     PreProc
hi def link luaStatement        Statement
hi def link luaString           String
hi def link luaStringLong       luaString
hi def link luaStringSpecial    SpecialChar
hi def link luaErrHand          Exception

let b:current_syntax = "lua"
if main_syntax == 'lua'
  unlet main_syntax
endif
