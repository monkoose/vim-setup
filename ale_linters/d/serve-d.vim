vim9script noclear

import './dub.vim'

def GetProjectRoot(bufnr: number): string
  const config = dub.FindDubConfig(bufnr)
  if !empty(config)
    return fnamemodify(config, ':h')
  endif

  return ''
enddef

ale#linter#Define('d', {
  name: 'serve-d',
  executable: 'serve-d',
  command: '%e',
  lsp: 'stdio',
  project_root: GetProjectRoot,
  lsp_config: {rootPatterns: ["dub.json", "dub.sdl"]},
})
