let mapleader="\<Space>"
set clipboard=unnamedplus
nnoremap <leader>d "_d
nnoremap <leader>w :w<cr>
nnoremap <leader>s :source ~/.vimrc<cr>
nnoremap <leader>f :GitFiles<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>t :Tags<cr>
set nu rnu
set t_Co=256
set splitright splitbelow
imap jk <Esc>
imap kj <Esc>
:command! -narg=+ Fsh :!fish -c '<args>'
autocmd vimenter * ++nested colorscheme gruvbox
set bg=dark
