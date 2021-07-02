let mapleader="\<Space>"
set clipboard=unnamedplus
nnoremap <leader>d "_d
nnoremap <leader>w :w<cr>

:command! -narg=+ Fsh :!fish -c '<args>'
