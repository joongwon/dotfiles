set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set number
set list
set listchars=tab:→\ ,eol:¬,nbsp:·,trail:•,extends:⟩,precedes:⟨
set modeline
set wrap
set hlsearch
set incsearch
set backspace=indent,eol,start
set termguicolors
set relativenumber
set autoread

digraph ll  8467 " ℓ
digraph #>  8614 " ↦
digraph =v  8659 " ⇓
digraph /E  8708 " ∄
digraph \-  8866 " ⊢
digraph </ 10216 " ⟨
digraph /> 10217 " ⟩

let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

nnoremap <C-,> :edit $MYVIMRC<CR>

augroup filetype
  au!
  autocmd BufNewFile,BufRead *.sl setlocal filetype=scheme
augroup END

call plug#begin()

Plug 'vim-python/python-syntax'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline-themes'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'whonore/Coqtail'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

Plug 'maxmellon/vim-jsx-pretty'

Plug 'github/copilot.vim'
Plug 'DanBradbury/copilot-chat.vim'

call plug#end()

nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fg :GFiles<CR>
nnoremap <Leader>fl :Lines<CR>

nnoremap <F5> :NERDTreeToggle<CR>

imap <C-l> <Plug>(copilot-accept-word)<C-O>:call popup_clear(1)<CR>
imap <C-;> <Plug>(copilot-accept-line)
imap <expr> <C-S-l> copilot#Accept()
let g:copilot_no_tab_map = v:true

colorscheme catppuccin_mocha

let g:airline_theme = 'catppuccin_mocha'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.linenr = 'ln:'
let g:airline_symbols.colnr = ' co:'

let g:coqtail_coq_path = ''

if executable('rust-analyzer')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'rust-analyzer',
        \ 'cmd': {server_info->['rust-analyzer']},
        \ 'allowlist': ['rust'],
        \ })
endif
if executable('tinymist')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'tinymist',
        \ 'cmd': {server_info->['tinymist']},
        \ 'allowlist': ['typst'],
        \ })
endif
if executable('ocamllsp')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'ocamllsp',
        \ 'cmd': {server_info->['ocamllsp']},
        \ 'allowlist': ['ocaml'],
        \ })
endif
if executable('npx')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->['npx', 'typescript-language-server', '--stdio']},
        \ 'allowlist': ['typescript', 'javascript', 'typescriptreact', 'javascriptreact'],
        \ })
endif

function! s:enable_fold() abort
  setlocal foldmethod=expr
  setlocal foldexpr=lsp#ui#vim#folding#foldexpr()
  setlocal foldtext=lsp#ui#vim#folding#foldtext()
endfunction
function! s:disable_fold() abort
  setlocal foldmethod=manual
  setlocal foldtext=foldtext()
  setlocal foldexpr=0
endfunction
command! LspEnableFold call s:enable_fold()
command! LspDisableFold call s:disable_fold()
function! s:on_lsp_buffer_enabled() abort
  setlocal signcolumn=yes
  if exists('+tagfunc')
    setlocal tagfunc=lsp#tagfunc
  endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [d <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]d <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  nmap <buffer> <leader>ca <plug>(lsp-code-action)
  nnoremap <buffer> <expr><c-j> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-k> lsp#scroll(-4)
  let g:lsp_format_sync_timeout = 1000
endfunction
augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
let g:lsp_diagnostics_virtual_text_prefix = " ‣ "
let g:lsp_diagnostics_virtual_text_align = "after"

hi link LspWarningHighlight WarningMsg
hi link LspWarningText WarningMsg
