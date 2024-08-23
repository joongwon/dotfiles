lang en_US.UTF-8
set expandtab
set ts=2
set sw=2
set sts=2
set cindent
set autoindent
set nu
set list
set listchars=tab:→\ ,eol:¬,nbsp:·,trail:•,extends:⟩,precedes:⟨
set modeline
set signcolumn=yes
set nowrap
set hlsearch
set incsearch
set backspace=indent,eol,start
set foldcolumn=auto:5
set foldlevel=99
set foldlevelstart=99
set foldenable
filetype indent plugin on

autocmd TermOpen * call OnTerminalOpen()
function OnTerminalOpen()
    set nonu
    set listchars=tab:→\ ,nbsp:·,trail:•,extends:⟩,precedes:⟨
    set showbreak=""
endfunction

let g:python_highlight_string_format = 1

" plugins
call plug#begin()

Plug 'vim-python/python-syntax'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline-themes'
Plug 'github/copilot.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'whonore/Coqtail'
Plug 'tikhomirov/vim-glsl'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'stevearc/aerial.nvim'
Plug 'kevinhwang91/promise-async'
Plug 'kevinhwang91/nvim-ufo'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'

Plug 'kaarmu/typst.vim'
Plug 'sbdchd/neoformat'

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'rescript-lang/vim-rescript'

call plug#end()

nmap gd <cmd>lua vim.lsp.buf.definition()<CR>
nmap gi <cmd>lua vim.lsp.buf.implementation()<CR>
nmap <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nmap <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
nmap [d <cmd>lua vim.diagnostic.goto_prev()<CR>
nmap ]d <cmd>lua vim.diagnostic.goto_next()<CR>
nmap K <cmd>lua vim.lsp.buf.hover()<CR>
nmap zR <cmd>lua require'ufo'.openAllFolds()<CR>
nmap zM <cmd>lua require'ufo'.closeAllFolds()<CR>

augroup my_filetype
    au!
    autocmd FileType ocaml setlocal ts=2 sw=2 sts=2 nocindent
    autocmd FileType dune  setlocal nocindent
    autocmd FileType markdown setlocal nocindent
    autocmd FileType rust setlocal ts=2 sw=2 sts=2
    autocmd FileType typescriptreact setlocal nocindent
    autocmd Syntax python syn keyword pythonMatchStatement match case
    autocmd Syntax python hi def link pythonMatchStatement Conditional
augroup END

let g:copilot_filetypes = {
      \ 'text': v:false,
      \ 'markdown': v:false,
      \ 'typst': v:false,
      \ }

let NERDTreeCaseSensitiveSort = 1

colorscheme catppuccin_mocha
set termguicolors
highlight Normal guibg=NONE
highlight Comment guifg=#797d9c
highlight LineNr guifg=#727594

let g:opambin = substitute(system('opam var bin'),'\n$','','''')
let g:neoformat_ocaml_ocamlformat = {
            \ 'exe': g:opambin . '/ocamlformat',
            \ 'no_append': 1,
            \ 'stdin': 1,
            \ 'args': ['--enable-outside-detected-project', '--name', '"%:p"', '-']
            \ }

let g:neoformat_enabled_ocaml = ['ocamlformat']

augroup fmt
  autocmd!
  autocmd BufWritePre * Neoformat
augroup END

dig \- 8866  " ⊢

lua << EOF
require"mason".setup()
require"mason-lspconfig".setup()

-- setup lsp with folding
local capabilities = require'cmp_nvim_lsp'.default_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}
local lspconfig = require'lspconfig'
local language_servers = {
  'rust_analyzer',
  'tsserver',
  'pyright',
  'ocamllsp',
  'typst_lsp',
}
for _, server in ipairs(language_servers) do
  lspconfig[server].setup{
    capabilities = capabilities,
  }
end

require'ufo'.setup{}
local cmp = require'cmp'
cmp.setup{
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert{},
  sources = cmp.config.sources{
    { name = 'nvim_lsp' },
  },
}
require'aerial'.setup{
  filter_kind = {
    'Class',
    'Function',
    'Method',
    'Property',
    'Field',
    'Enum',
    'Interface',
    'Module',
    'Namespace',
    'Struct',
    'Variable',
  },
}
EOF
