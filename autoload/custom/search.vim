vim9script

export def Selection(backward: bool = false): string
  const cmd = backward ? '?' : '/'
  const pattern = getregion(getpos('v'), getpos('.'), {type: mode()})
                    ->map((_, v) => escape(v, cmd .. '\'))
                    ->join('\n')
  return $"\<Esc>{cmd}\\V{pattern}\<CR>n"
enddef
