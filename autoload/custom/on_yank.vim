vim9script noclear

if empty(prop_type_get('yank_prop'))
  prop_type_add('yank_prop', { highlight: "HighlightedyankRegion", combine: true, priority: 100})
endif

def custom#on_yank#highlight(timeout: number)
  if v:event.operator == 'y' && !(empty(v:event.regtype))
    const start = getpos("'[")
    const start_line = start[1]
    const start_col = start[2] + start[3]
    const end_line = getpos("']")[1]
    const shift = start_line == end_line ? start_col - 1 : 0
    const length = len(v:event.regcontents[-1]) + 1 + shift

    if v:event.visual && v:event.regtype =~ "\<C-v>"
      # const virtc = strwidth(strpart(getline(start_line), 0, start_col + 1))
      # var i = 0
      # for line in range(start_line, end_line)
      #   const line_str = getline(line)
      #   if strdisplaywidth(line_str) >= virtc
      #     const col = strlen(strcharpart(line_str, 0, virtc))
      #     const end_l = strlen(v:event.regcontents[i])
      #     prop_add(line, col - 1, { length: end_l, type: 'yank_prop' })
      #   endif
      #   i += 1
      # endfor
      return
    else
      timer_start(1, (_) => prop_add(start_line,
                                    start_col,
                                    { end_lnum: end_line, end_col: length, type: 'yank_prop' }))
    endif
    timer_start(timeout, (_) => prop_remove({ type: 'yank_prop' }))
  endif
enddef

defcompile
