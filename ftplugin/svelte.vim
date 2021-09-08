vim9script

def ToggleLineComment(map: string)
    if !!IsInsideHtmlBlock()
        if match(getline('.'), '^\s*<!--\s*.*\s*-->$') == -1
            :execute 'keepp s/^\s*\zs.*/<!-- & -->/'
        else
            :execute 'keepp s/\(^\s*\)<!--\s*\(.\{-}\)\s*-->/\1\2'
        endif
    else
        :Commentary
    endif
enddef

def IsInsideHtmlBlock(): number
    var inside_html = 1
    if search('^\s*</style', 'Wn') > 0
        if search('^\s*<style', 'Wbn') > 0
            inside_html = 0
        endif
    elseif search('^\s*</script', 'Wn') > 0
        if search('^\s*<script', 'Wbn') > 0
            inside_html = 0
        endif
    endif

    return inside_html
enddef

nnoremap gcc <Cmd>call <SID>ToggleLineComment('gcc')<CR>
vnoremap gc :call <SID>ToggleLineComment('gc')<CR>

defcompile
