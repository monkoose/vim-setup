vim9script noclear

if empty(prop_type_get('yank_prop'))
  prop_type_add('yank_prop', {
    highlight: "QuickFixLine",
    combine: true,
    priority: 100,
  })
endif

export def Highlight(timeout: number)
  if !v:event.visual && v:event.operator == 'y' && !(empty(v:event.regtype))
    const start = getpos("'[")
    const start_line = start[1]
    const start_col = start[2] + start[3]
    const end_line = getpos("']")[1]
    const shift = start_line == end_line ? start_col - 1 : 0
    const length = len(v:event.regcontents[-1]) + 1 + shift

    prop_add(start_line, start_col, {
      end_lnum: end_line, end_col: length, type: 'yank_prop'
    })

    timer_start(timeout, (_) => prop_remove({type: 'yank_prop'}, start_line, end_line))
  endif
enddef
