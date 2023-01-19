vim9script noclear

ale#linter#Define('d', {
  name: 'serve-d',
  executable: 'serve-d',
  command: '%e',
  lsp: 'stdio',
  project_root: '/home/monkoose/Downloads/hello',
  lsp_config: {rootPatterns: ["dub.json", "dub.sdl"]},
})
