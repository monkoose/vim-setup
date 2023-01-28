vim9script noclear

def RunDscannerCommand(bufnr: number): any
  const file = fnamemodify(bufname(bufnr), '.')
  return "dscanner --styleCheck " .. file
enddef

def Handle(bufnr: number, lines: list<string>): list<dict<any>>
  # Matches patterns lines like the following:
  # source/app.d(19:5)[error]: Expected `;` instead of `auto`
  # source/app.d(10:8)[warn]: Public declaration 'Simple' is undocumented.
  const pattern = '\v^(\f+)\((\d+)%(:(\d+))?\)\[(\w+)\]: (.+)$'
  var output = []
  const dir = expand($'#{bufnr}:p:h')

  for match in ale#util#GetMatches(lines, pattern)
    add(output, {
      filename: match[1],
      lnum: match[2],
      col: match[3],
      type: match[4] == 'warn' ? 'W' : 'E',
      text: match[5],
    })
  endfor

  return output
enddef

ale#linter#Define('d', {
  name: 'dscanner',
  executable: 'dscanner',
  command: RunDscannerCommand,
  callback: Handle,
  output_stream: 'stdout',
})
