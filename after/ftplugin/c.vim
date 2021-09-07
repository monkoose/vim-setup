compiler gcc

let b:mymake_cmd = 'gcc -g -Wall -Og -o ' .. expand('%:t:r')
