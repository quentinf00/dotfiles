let mapleader="\<Space>"
set clipboard=unnamedplus
nnoremap <leader>d "_d
nnoremap <leader>w :w<cr>
nnoremap <leader>s :source ~/.vimrc<cr>
nnoremap <leader>f :GitFiles<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>t :Tags<cr>
set nu rnu
imap jk <Esc>
imap kj <Esc>
:command! -narg=+ Fsh :!fish -c '<args>'
