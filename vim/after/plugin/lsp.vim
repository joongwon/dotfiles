vim9script

g:LspOptionsSet({
  showDiagWithVirtualText: true,
  popupBorder: true,
})

def OnLspAttached()
  setlocal tagfunc=lsp#lsp#TagFunc
  setlocal keywordprg=:LspHover
  nnoremap <buffer> gd <Cmd>LspGotoDefinition<CR>
  nnoremap <buffer> gi <Cmd>LspGotoImpl<CR>
  nnoremap <buffer> ]d <Cmd>LspDiag next<CR>
  nnoremap <buffer> [d <Cmd>LspDiag prev<CR>
enddef
augroup LspSettings
  autocmd!
  autocmd User LspAttached OnLspAttached()
augroup END

var lspServers: list<dict<any>> = []

var tsPath = exepath('typescript-language-server')
if tsPath !=# ''
  add(lspServers, {
    name: 'typescript-language-server',
    filetype: ['typescript', 'typescriptreact', 'javascript', 'javascriptreact'],
    path: tsPath,
    args: ['--stdio']
  })
endif

var ocamlPath = exepath('ocamllsp')
if ocamlPath !=# ''
  add(lspServers, {
    name: 'ocamllsp',
    filetype: ['ocaml'],
    path: ocamlPath
  })
endif

g:LspAddServer(lspServers)
