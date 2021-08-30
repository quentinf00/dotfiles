let mapleader="\<Space>"
set clipboard=unnamedplus
set hidden
nnoremap <leader>d "_d
nnoremap <leader>w :w<cr>
nnoremap <leader>s :source ~/.vimrc<cr>
nnoremap <leader>f :GitFiles<cr>
nnoremap <leader>h :History<cr>
nnoremap <leader>F :Files<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>/ :BLines<cr>
nnoremap <leader>t :Tags<cr>
set nu rnu
set t_Co=256
set splitright splitbelow
imap jk <Esc>
imap kj <Esc>
autocmd vimenter * ++nested colorscheme gruvbox
set bg=dark
set foldmethod=manual

let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

nnoremap <leader>j lnext
nnoremap <leader>k lprevious
nnoremap <C-j> cnext
nnoremap <C-k> cprevious
