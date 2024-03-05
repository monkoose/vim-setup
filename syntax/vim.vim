vim9script

finish
if exists('b:current_syntax')
  finish
endif

var is_vim9: bool = getline(1, 10)->match('^\s*vim9') != -1

syn sync minlines=300
syn case match

if is_vim9
  syn match vimComment "#.*$"
else
endif

syn match vimHereDoc "\s=<<\s" nextgroup=vimHereDocRegion skipwhite

syntax region vimHereDocRegion
    \ matchgroup=vimDeclareHereDoc
    \ start="\%(trim\s\+\)\=\z(\L\S*\)\s*$"
    \ matchgroup=vimDeclareHereDoc
    \ end="^\s*\z1$"
    \ contained

syntax region vimHereDocRegion
    \ matchgroup=vimDeclareHereDoc
    \ start="\%(trim\s\+\)\=eval\s\+\%(trim\s\+\)\=\z(\L\S*\)\s*$"
    \ matchgroup=vimDeclareHereDoc
    \ end="^\s*\z1$"
    \ contained
    \ contains=vimHereDocExpr,vimSILB,vimSIUB

syntax region vimHereDocExpr matchgroup=PreProc start="{{\@!" end="}" contained contains=@vimExpr oneline

hi default link vimComment Comment
hi default link vimDeclare Identifier
hi default link vimHereDoc vimDeclare
hi default link vimDeclareHereDoc vimDeclare
hi default link vimHereDocRegion String

b:current_syntax = 'vim'

# vim: sw=2 sts=2 et
