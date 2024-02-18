setlocal iskeyword+=-
setlocal shiftwidth=2

let b:coc_additional_keywords = ['-']

call custom#undo_ftplugin#Set('setl iskeyword< sw<')
call custom#undo_ftplugin#Set('unlet b:coc_additional_keywords')
