setlocal omnifunc=ale#completion#OmniFunc
let b:ale_disable_lsp = 0
nnoremap <buffer> <space>d <Cmd>ALEGoToDefinition<CR>
nnoremap <buffer> K <Cmd>ALEHover<CR>
