setlocal tabstop=4
let &l:commentstring = '// %s'
let &l:comments = 's1:/*,mb:*,ex:*/,s1:/+,mb:+,ex:+/,://'

call custom#undo_ftplugin#Set('setl tabstop< commentstring< comments<')
