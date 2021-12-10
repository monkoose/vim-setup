vim9script noclear

def custom#endofline#toggle(char: string)
    var line = getline('.')
    const str_len = strchars(line)
    const lastchar = strgetchar(line, str_len - 1)
    if lastchar ==# char2nr(char)
        line = strcharpart(line, 0, str_len - 1)
    else
        line = line .. char
    endif
    setline('.', line)
enddef

defcompile
