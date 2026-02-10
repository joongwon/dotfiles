syntax on
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
set background=light

let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

nnoremap <C-,> :tabe $MYVIMRC<CR>

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.linenr = 'ln:'
let g:airline_symbols.colnr = ' co:'

nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fg :GFiles<CR>
nnoremap <Leader>fr :Rg<CR>

colorscheme gruvbox
let g:airline_theme = 'gruvbox'
let g:gruvbox_contrast_light = 'hard'

imap <M-;> <Plug>(copilot-accept-word)<C-O>:call popup_clear(1)<CR>
imap <C-;> <Plug>(copilot-accept-line)
imap <expr> <M-C-;> copilot#Accept()
let g:copilot_no_tab_map = v:true

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
if executable('typescript-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->['typescript-language-server', '--stdio']},
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

"let g:lsp_use_native_client = 1

digraph ?< 8828    " ≼
digraph !< 8928    " ⋠
digraph ~>  8605 " ↝
digraph #>  8614 " ↦
digraph =^  8657 " ⇑
digraph =v  8659 " ⇓
digraph /E  8708 " ∄
digraph !(  8713 " ∉
digraph :=  8788 " ≔
digraph [_  8849 " ⊑
digraph _]  8850 " ⊒
digraph ]U  8851 " ⊓
digraph [U  8852 " ⊔
digraph O+  8853 " ⊕
digraph \-  8866 " ⊢
digraph /-  8876 " ⊬
digraph +T  8868 " ⊤
digraph \=  8872 " ⊨
digraph /=  8877 " ⊭
digraph []  9633 " □
digraph [>  9655 " ▷
digraph [[ 10214
digraph ]] 10215
digraph <( 10216 " ⟨
digraph )> 10217 " ⟩

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

" === Mathematical Script CAPITAL A-Z ===
digraph /A 119964   " 𝒜 MATHEMATICAL SCRIPT CAPITAL A (U+1D49C)
digraph /B 8492     " ℬ SCRIPT CAPITAL B (U+212C)
digraph /C 119966   " 𝒞 MATHEMATICAL SCRIPT CAPITAL C (U+1D49E)
digraph /D 119967   " 𝒟 MATHEMATICAL SCRIPT CAPITAL D (U+1D49F)
digraph /E 8496     " ℰ SCRIPT CAPITAL E (U+2130)
digraph /F 8497     " ℱ SCRIPT CAPITAL F (U+2131)
digraph /G 119970   " 𝒢 MATHEMATICAL SCRIPT CAPITAL G (U+1D4A2)
digraph /H 8459     " ℋ SCRIPT CAPITAL H (U+210B)
digraph /I 8464     " ℐ SCRIPT CAPITAL I (U+2110)
digraph /J 119973   " 𝒥 MATHEMATICAL SCRIPT CAPITAL J (U+1D4A5)
digraph /K 119974   " 𝒦 MATHEMATICAL SCRIPT CAPITAL K (U+1D4A6)
digraph /L 8466     " ℒ SCRIPT CAPITAL L (U+2112)
digraph /M 8499     " ℳ SCRIPT CAPITAL M (U+2133)
digraph /N 119977   " 𝒩 MATHEMATICAL SCRIPT CAPITAL N (U+1D4A9)
digraph /O 119978   " 𝒪 MATHEMATICAL SCRIPT CAPITAL O (U+1D4AA)
digraph /P 119979   " 𝒫 MATHEMATICAL SCRIPT CAPITAL P (U+1D4AB)
digraph /Q 119980   " 𝒬 MATHEMATICAL SCRIPT CAPITAL Q (U+1D4AC)
digraph /R 8475     " ℛ SCRIPT CAPITAL R (U+211B)
digraph /S 119982   " 𝒮 MATHEMATICAL SCRIPT CAPITAL S (U+1D4AE)
digraph /T 119983   " 𝒯 MATHEMATICAL SCRIPT CAPITAL T (U+1D4AF)
digraph /U 119984   " 𝒰 MATHEMATICAL SCRIPT CAPITAL U (U+1D4B0)
digraph /V 119985   " 𝒱 MATHEMATICAL SCRIPT CAPITAL V (U+1D4B1)
digraph /W 119986   " 𝒲 MATHEMATICAL SCRIPT CAPITAL W (U+1D4B2)
digraph /X 119987   " 𝒳 MATHEMATICAL SCRIPT CAPITAL X (U+1D4B3)
digraph /Y 119988   " 𝒴 MATHEMATICAL SCRIPT CAPITAL Y (U+1D4B4)
digraph /Z 119989   " 𝒵 MATHEMATICAL SCRIPT CAPITAL Z (U+1D4B5)

" === Mathematical Script SMALL a-z ===
digraph /a 119990   " 𝒶 MATHEMATICAL SCRIPT SMALL A (U+1D4B6)
digraph /b 119991   " 𝒷 MATHEMATICAL SCRIPT SMALL B (U+1D4B7)
digraph /c 119992   " 𝒸 MATHEMATICAL SCRIPT SMALL C (U+1D4B8)
digraph /d 119993   " 𝒹 MATHEMATICAL SCRIPT SMALL D (U+1D4B9)
digraph /e 8495     " ℯ SCRIPT SMALL E (U+212F)
digraph /f 119995   " 𝒻 MATHEMATICAL SCRIPT SMALL F (U+1D4BB)
digraph /g 8458     " ℊ SCRIPT SMALL G (U+210A)
digraph /h 119997   " 𝒽 MATHEMATICAL SCRIPT SMALL H (U+1D4BD)
digraph /i 119998   " 𝒾 MATHEMATICAL SCRIPT SMALL I (U+1D4BE)
digraph /j 119999   " 𝒿 MATHEMATICAL SCRIPT SMALL J (U+1D4BF)
digraph /k 120000   " 𝓀 MATHEMATICAL SCRIPT SMALL K (U+1D4C0)
digraph /l 120001   " 𝓁 MATHEMATICAL SCRIPT SMALL L (U+1D4C1)
digraph /m 120002   " 𝓂 MATHEMATICAL SCRIPT SMALL M (U+1D4C2)
digraph /n 120003   " 𝓃 MATHEMATICAL SCRIPT SMALL N (U+1D4C3)
digraph /o 8500     " ℴ SCRIPT SMALL O (U+2134)
digraph /p 120005   " 𝓅 MATHEMATICAL SCRIPT SMALL P (U+1D4C5)
digraph /q 120006   " 𝓆 MATHEMATICAL SCRIPT SMALL Q (U+1D4C6)
digraph /r 120007   " 𝓇 MATHEMATICAL SCRIPT SMALL R (U+1D4C7)
digraph /s 120008   " 𝓈 MATHEMATICAL SCRIPT SMALL S (U+1D4C8)
digraph /t 120009   " 𝓉 MATHEMATICAL SCRIPT SMALL T (U+1D4C9)
digraph /u 120010   " 𝓊 MATHEMATICAL SCRIPT SMALL U (U+1D4CA)
digraph /v 120011   " 𝓋 MATHEMATICAL SCRIPT SMALL V (U+1D4CB)
digraph /w 120012   " 𝓌 MATHEMATICAL SCRIPT SMALL W (U+1D4CC)
digraph /x 120013   " 𝓍 MATHEMATICAL SCRIPT SMALL X (U+1D4CD)
digraph /y 120014   " 𝓎 MATHEMATICAL SCRIPT SMALL Y (U+1D4CE)
digraph /z 120015   " 𝓏 MATHEMATICAL SCRIPT SMALL Z (U+1D4CF)
