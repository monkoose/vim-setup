vim9script

def PasteBlankline(linenr: number)
  const lines = repeat([''], v:count1)
  append(linenr, lines)
enddef

export def PasteBlanklineAbove()
  PasteBlankline(line('.') - 1)
enddef

export def PasteBlanklineBelow()
  PasteBlankline(line('.'))
enddef

def PrintOptionValue(option: string)
  execute 'set ' .. option .. '?'
enddef

export def ToggleOption(option: string)
  execute('setlocal ' .. option .. '!')
  PrintOptionValue(option)
enddef

export def SwitchOption(option: string, first: any, second: any)
  const opt = '&' .. option
  const new_value = getbufvar('', opt) == first ? second : first
  setbufvar('', opt, new_value)
  PrintOptionValue(option)
enddef
