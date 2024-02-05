call cursor(1, 1)
setlocal spell

if empty(getline(1))
  startinsert
endif
