vim9script

if empty(prop_type_get('yank_prop'))
  prop_type_add('yank_prop', { highlight: "HighlightedyankRegion", combine: true, priority: 100})
endif

def HighlightOnYank(timeout: number)
  if v:event.operator == 'y' && !(empty(v:event.regtype))
    const pos1 = getcharpos("'[")
    const pos2 = getcharpos("']")
    const start = [pos1[1], pos1[2] + pos1[3]]
    const end = [pos2[1], pos2[2] + pos2[3]]
    prop_add(start[0], start[1], { end_lnum: end[0], end_col: end[1] + 1, type: 'yank_prop' })
    timer_start(timeout, (_) => prop_remove({ type: 'yank_prop' }, start[0], end[0]))
  endif
enddef

augroup PostYank
  autocmd!
  autocmd TextYankPost * silent call HighlightOnYank(200)
augroup END

defcompile
