vim9script noclear

def PasteBlankline(linenr: number)
  append(linenr, repeat([''], v:count1))
enddef

export def PasteBlanklineAbove()
  PasteBlankline(line('.') - 1)
enddef

export def PasteBlanklineBelow()
  PasteBlankline(line('.'))
enddef

def PrintOptionValue(option: string)
  exe $'set {option}?'
enddef

export def ToggleOption(option: string)
  execute($'setlocal {option}!')
  PrintOptionValue(option)
enddef

export def SwitchOption(option: string, first: any, second: any)
  const opt = '&' .. option
  const new_value = getbufvar('', opt) == first ? second : first
  setbufvar('', opt, new_value)
  PrintOptionValue(option)
enddef
