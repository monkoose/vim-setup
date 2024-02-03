vim9script

if exists("b:current_syntax")
  finish
endif

syn sync minlines=300
syn case match
syntax iskeyword @,48-57,_,192-255,:,=,&

# Keywords within functions
syn keyword  goFunc         func
syn keyword  goReturn       return
syn keyword  goConditional  if else switch select
syn keyword  goLabel        case default
syn keyword  goRepeat       for
syn keyword  goStatement    defer go goto break continue fallthrough
syn keyword  goKeyword      var const type chan range struct interface map import := package &&
syn match  goKeyword  '||' display

syn match goDelimiter  "," display
syn match goDelimiter  ";" display
syn match goBracket  "(" display
syn match goBracket  ")" display
syn match goBracket  "]" display
syn match goBracket  "\[" display
syn match goBracket  "}" display
syn match goBracket  "{" display

syn keyword goNil  nil
syn keyword goBool  true false

# Comments; their contents
syn keyword  goTodo  TODO FIXME XXX BUG NOTE  contained
syn region  goComment  start="//"   end="$"    display contains=goTodo,@Spell
syn region  goComment  start="/\*"  end="\*/"  contains=goTodo,@Spell

# Go escapes
syn match  goEscapeOctal  "\\[0-7]\{3}"  display contained
syn match  goEscapeC      +\\[abfnrtv\\'"]+  display contained
syn match  goEscapeX      "\\x\x\{2}"  display contained
syn match  goEscapeU      "\\u\x\{4}"  display contained
syn match  goEscapeBigU   "\\U\x\{8}"  display contained
syn match  goEscapeError  +\\[^0-7xuUabfnrtv\\'"]+  display contained

# [n] notation is valid for specifying explicit argument indexes
# 1. Match a literal % not preceded by a %.
# 2. Match any number of -, #, 0, space, or +
# 3. Match * or [n]* or any number or nothing before a .
# 4. Match * or [n]* or any number or nothing after a .
# 5. Match [n] or nothing before a verb
# 6. Match a formatting verb
syn match  goFormatSpecifier   /\
      \%([^%]\%(%%\)*\)\
      \zs%[-#0 +]*\
      \%(\%(\%(\[\d\+\]\)\=\*\)\|\d\+\)\=\
      \%(\.\%(\%(\%(\[\d\+\]\)\=\*\)\|\d\+\)\=\)\=\
      \%(\[\d\+\]\)\=[vTtbcdoqxXUeEfFgGspw]/ contained display

# Strings
syn region   goString     start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=goFormatSpecifier,goEscapeOctal,goEscapeC,goEscapeX,goEscapeU,goEscapeBigU,goEscapeError,@Spell
syn region   goRawString  start=+`+ end=+`+ contains=goFormatSpecifier

# Characters
syn region  goCharacter  start=+'+ skip=+\\\\\|\\'+ end=+'+ contains=goEscapeOctal,goEscapeC,goEscapeX,goEscapeU,goEscapeBigU


# Default highlights
hi def link  goStatement         Statement
hi def link  goFunc              Function
hi def link  goConditional       Conditional
hi def link  goLabel             Label
hi def link  goRepeat            Repeat
hi def link  goKeyword           Identifier
hi def link  goComment           Comment
hi def link  goTodo              Todo
hi def link  goFormatSpecifier   goSpecialString
hi def link  goEscapeOctal       goSpecialString
hi def link  goEscapeC           goSpecialString
hi def link  goEscapeX           goSpecialString
hi def link  goEscapeU           goSpecialString
hi def link  goEscapeBigU        goSpecialString
hi def link  goSpecialString     Special
hi def link  goEscapeError       Error
hi def link  goString            String
hi def link  goRawString         String
hi def link  goCharacter         Character
hi def link  goNil               Constant
hi def link  goBool              Boolean
# :GoCoverage commands
hi def link goCoverageNormalText Comment

b:current_syntax = "go"

# vim: sw=2 sts=2 et
