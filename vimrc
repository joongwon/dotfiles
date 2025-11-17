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
set guifont=Julia\ Mono\ 10

let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

nnoremap <C-,> :tabe $MYVIMRC<CR>

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
let g:coqtail_noindent_comment = 1
let g:coqtail_indent_on_dot = 1

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

digraph ?< 8828    " ≼
digraph !< 8928    " ⋠
"digraph ll  8467 " ℓ
digraph ~>  8605 " ↝
digraph #>  8614 " ↦
digraph =^  8657 " ⇑
digraph =v  8659 " ⇓
digraph /E  8708 " ∄
digraph !(  8713 " ∉
digraph :=  8788 " ≔
digraph [_  8849 " ⊑
digraph ]U  8851 " ⊓
digraph O+  8853 " ⊕
digraph \-  8866 " ⊢
digraph /-  8876 " ⊬
digraph +T  8868 " ⊤
digraph \=  8872 " ⊨
digraph /=  8877 " ⊭
digraph [[ 10214
digraph ]] 10215
digraph <[ 10216 " ⟨
digraph ]> 10217 " ⟩

digraph AA 120120
digraph BB 120121
digraph CC 8450
digraph DD 120123
digraph EE 120124
digraph FF 120125
digraph GG 120126
digraph HH 8461
digraph II 120128
digraph JJ 120129
digraph KK 120130
digraph LL 120131
digraph MM 120132
digraph NN 8469
digraph OO 120134
digraph PP 8473
digraph QQ 8474
digraph RR 8477
digraph SS 120138
digraph TT 120139
digraph UU 120140
digraph VV 120141
digraph WW 120142
digraph XX 120143
digraph YY 120144
digraph ZZ 8484

digraph aa 120146 " 𝕒
digraph bb 120147
digraph cc 120148
digraph dd 120149
digraph ee 120150
digraph ff 120151
digraph gg 120152
digraph hh 120153
digraph ii 120154
digraph jj 120155
digraph kk 120156
digraph ll 120157
digraph mm 120158
digraph nn 120159
digraph oo 120160
digraph pp 120161
digraph qq 120162
digraph rr 120163
digraph ss 120164
digraph tt 120165
digraph uu 120166
digraph vv 120167
digraph ww 120168
digraph xx 120169
digraph yy 120170
digraph zz 120171

digraph /A 120016 " 𝓐
digraph /B 120017
digraph /C 120018
digraph /D 120019
digraph /E 120020
digraph /F 120021
digraph /G 120022
digraph /H 120023
digraph /I 120024
digraph /J 120025
digraph /K 120026
digraph /L 120027
digraph /M 120028
digraph /N 120029
digraph /O 120030
digraph /P 120031 " 𝓟
digraph /Q 120032
digraph /R 120033
digraph /S 120034
digraph /T 120035
digraph /U 120036
digraph /V 120037
digraph /W 120038
digraph /X 120039
digraph /Y 120040
digraph /Z 120041

digraph /a 120042
digraph /b 120043
digraph /c 120044
digraph /d 120045
digraph /e 120046
digraph /f 120047
digraph /g 120048
digraph /h 120049
digraph /i 120050
digraph /j 120051
digraph /k 120052
digraph /l 120053
digraph /m 120054
digraph /n 120055
digraph /o 120056
digraph /p 120057
digraph /q 120058
digraph /r 120059
digraph /s 120060
digraph /t 120061
digraph /u 120062
digraph /v 120063
digraph /w 120064
digraph /x 120065
digraph /y 120066
digraph /z 120067
