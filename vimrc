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
set mouse=a

digraph ll  8467 " ℓ
digraph #>  8614 " ↦
digraph =v  8659 " ⇓
digraph /E  8708 " ∄
digraph [_  8849 " ⊑
digraph \-  8866 " ⊢
digraph \=  8872 " ⊨
digraph </ 10216 " ⟨
digraph /> 10217 " ⟩

digraph AA 120120 " 𝔸
digraph BB 120121 " 𝔹
digraph CC   8468 " ℂ
digraph DD 120123 " 𝔻
digraph EE 120124 " 𝔼
digraph FF 120125 " 𝔽
digraph GG 120126 " 𝔾
digraph HH   8469 " ℍ
digraph II 120128 " 𝕀
digraph JJ 120129 " 𝕁
digraph KK 120130 " 𝕂
digraph LL 120131 " 𝕃
digraph MM 120132 " 𝕄
digraph NN   8465 " ℕ
digraph OO 120134 " 𝕆
digraph PP   8473 " ℙ
digraph QQ   8474 " ℚ
digraph RR   8477 " ℝ
digraph SS 120138 " 𝕊
digraph TT 120139 " 𝕋
digraph UU 120140 " 𝕌
digraph VV 120141 " 𝕍
digraph WW 120142 " 𝕎
digraph XX 120143 " 𝕏
digraph YY 120144 " 𝕐
digraph ZZ   8484 " ℤ



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

"Plug 'prabirshrestha/vim-lsp'
Plug 'joongwon/vim-lsp', { 'branch': 'remove-codeaction-only' }
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

Plug 'maxmellon/vim-jsx-pretty'

Plug 'github/copilot.vim'
Plug 'DanBradbury/copilot-chat.vim'

Plug 'lervag/vimtex', { 'tag': 'v2.15' }

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
        \   'name': 'ocamllsp',
        \   'cmd': {server_info->['ocamllsp']},
        \   'allowlist': ['ocaml'],
        \   'workspace_config': {
        \     'codelens': { 'enabled': v:true },
        \   },
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
  setlocal tagfunc=lsp#tagfunc
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [d <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]d <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  nmap <buffer> <leader>ca <plug>(lsp-code-action)
  imap <buffer> <c-space> <plug>(asyncomplete_force_refresh)
  nnoremap <buffer> <expr><c-j> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-k> lsp#scroll(-4)
endfunction
augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
let g:lsp_diagnostics_virtual_text_prefix = " ‣ "
let g:lsp_diagnostics_virtual_text_align = "after"

hi link LspWarningHighlight WarningMsg
hi link LspWarningText WarningMsg
