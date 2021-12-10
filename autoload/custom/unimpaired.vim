vim9script

def Pasteblankline(linenr: number)
    const lines = repeat([''], v:count1)
    append(linenr, lines)
enddef

def custom#unimpaired#PasteBlanklineAbove()
    Pasteblankline(line('.') - 1)
enddef

def custom#unimpaired#PasteBlanklineBelow()
    Pasteblankline(line('.'))
enddef

def PrintOptionValue(option: string)
    :execute 'set ' .. option .. '?'
enddef

def custom#unimpaired#ToggleOption(option: string)
    execute('setlocal ' .. option .. '!')
    PrintOptionValue(option)
enddef

def custom#unimpaired#SwitchOption(option: string, first: string, second: string)
    const opt_value = trim(execute('echo &' .. option))

    if opt_value ==# first
        execute('set ' .. option .. '=' .. second)
    else
        execute('set ' .. option .. '=' .. first)
    end

    PrintOptionValue(option)
enddef

defcompile
