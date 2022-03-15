vim9script

def Pasteblankline(linenr: number)
    const lines = repeat([''], v:count1)
    append(linenr, lines)
enddef

export def PasteBlanklineAbove()
    Pasteblankline(line('.') - 1)
enddef

export def PasteBlanklineBelow()
    Pasteblankline(line('.'))
enddef

def PrintOptionValue(option: string)
    :execute 'set ' .. option .. '?'
enddef

export def ToggleOption(option: string)
    execute('setlocal ' .. option .. '!')
    PrintOptionValue(option)
enddef

export def SwitchOption(option: string, first: string, second: string)
    const opt_value = trim(execute('echo &' .. option))

    if opt_value ==# first
        execute('set ' .. option .. '=' .. second)
    else
        execute('set ' .. option .. '=' .. first)
    end

    PrintOptionValue(option)
enddef

defcompile
