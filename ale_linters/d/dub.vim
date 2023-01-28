vim9script noclear

const on_windows = has('win32')

def FindDubConfig(bufnr: number): string
  # Find a dub configuration file in ancestor paths.
  # The most dub-specific names will be tried first.
  for possible_filename in ['dub.sdl', 'dub.json', 'package.json']
    const dub_file: string = ale#path#FindNearestFile(bufnr, possible_filename)

    if !empty(dub_file)
      return dub_file
    endif
  endfor

  return ''
enddef

def GetDubCommand(bufnr: number): list<string>
  const ale_cache = getbufvar(bufnr, 'ale_dub_cache', null)
  if type(ale_cache) != v:t_none
    return ale_cache
  endif

  setbufvar(bufnr, 'ale_dub_cache', ['', ''])
  # If we can't run dub, then skip this command.
  if executable('dub')
    # Returning an empty string skips to the dmd command.
    const config = FindDubConfig(bufnr)

    # To support older dub versions, we just change the directory to the
    # directory where we found the dub config, and then run `dub describe`
    # from that directory.
    if !empty(config)
      setbufvar(bufnr, 'ale_dub_cache', [
        fnamemodify(config, ':h'),
        'dub describe --data-list  --data=import-paths ' ..
        '--data=string-import-paths --data=versions --data=debug-versions'
      ])
    endif
  endif

  return getbufvar(bufnr, 'ale_dub_cache')
enddef

def RunDubCommand(bufnr: number): any
  const [cwd, command] = GetDubCommand(bufnr)

  if empty(command)
    # If we can't run `dub`, just run `dmd`.
    return DMDCommand(bufnr, [], {})
  else
    return ale#command#Run(bufnr, command, DMDCommand, { cwd: cwd })
  endif
enddef

def DMDCommand(bufnr: number, dub_output: list<string>, _): string
  var import_list: list<string> = []
  var str_import_list: list<string> = []
  var versions_list: list<string> = []
  var deb_versions_list: list<string> = []
  var list_ind = 1
  var seen_line = 0

  # Build a list of options generated from dub, if available.
  # dub output each path or version on a single line.
  # Each list is separated by a blank line.
  # Empty list are represented by a blank line (followed and/or
  # preceded by a separation blank line)
  for l in dub_output
    var line = l
    # line still has end of line char on windows
    if on_windows
      line = substitute(line, '[\r\n]*$', '', '')
    endif

    if !empty(line)
      if list_ind == 1
        call add(import_list, '-I' .. ale#Escape(line))
      elseif list_ind == 2
        call add(str_import_list, '-J' .. ale#Escape(line))
      elseif list_ind == 3
        call add(versions_list, '-version=' .. ale#Escape(line))
      elseif list_ind == 4
        call add(deb_versions_list, '-debug=' .. ale#Escape(line))
      endif

      seen_line = 1
    elseif !seen_line
      # if list is empty must skip one empty line
      seen_line = 1
    else
      seen_line = 0
      list_ind += 1
    endif
  endfor

  return 'dmd ' .. join(import_list) .. ' ' ..
         join(str_import_list) .. ' ' ..
         join(versions_list) .. ' ' ..
         join(deb_versions_list) .. ' -o- -wi -vcolumns -c %t'
enddef

def Handle(bufnr: number, lines: list<string>): list<dict<any>>
  # Matches patterns lines like the following:
  # /tmp/tmp.qclsa7qLP7/file.d(1): Error: function declaration without return type.
  # /tmp/tmp.G1L5xIizvB.d(8,8): Error: module weak_reference is in file...
  const pattern = '\v^(\f+)\((\d+)%(,(\d+))?\): (\w+): (.+)$'
  var output = []
  const dir = expand($'#{bufnr}:p:h')

  for match in ale#util#GetMatches(lines, pattern)
    add(output, {
      # If dmd was invoked with relative path, match[1] is relative, otherwise it is absolute.
      # As we invoke dmd with the buffer path (in /tmp), this will generally be absolute already
      filename: ale#path#GetAbsPath(dir, match[1]),
      lnum: match[2],
      col: match[3],
      type: match[4] == 'Warning' || match[4] == 'Deprecation' ? 'W' : 'E',
      text: match[5],
    })
  endfor

  return output
enddef

ale#linter#Define('d', {
  name: 'dub',
  executable: 'dmd',
  command: RunDubCommand,
  callback: Handle,
  output_stream: 'stderr',
})
