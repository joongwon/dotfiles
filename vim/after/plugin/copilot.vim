vim9script

imap <M-;> <Plug>(copilot-accept-word)<C-O>:call popup_clear(1)<CR>
imap <C-;> <Plug>(copilot-accept-line)
imap <expr> <M-C-;> copilot#Accept()

g:copilot_no_tab_map = v:true
