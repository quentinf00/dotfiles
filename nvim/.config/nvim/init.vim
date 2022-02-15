packadd! lsp
packadd! neorg
packadd! ts

let mapleader="\<Space>"
set clipboard=unnamedplus
set hidden
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>/ <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>w :w<cr>
set nu rnu
set t_Co=256
set splitright splitbelow
imap jk <Esc>
imap kj <Esc>
autocmd vimenter * ++nested colorscheme gruvbox
set bg=dark
set foldmethod=manual

call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
" Plug 'justinmk/vim-sneak'
" Plug 'wellle/targets.vim'
Plug 'ggandor/lightspeed.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'RRethy/nvim-treesitter-textsubjects'
" Plug 'ojroques/vim-oscyank'
Plug 'nvim-neorg/neorg'
call plug#end()



" y:w^M'Ti^C^M^M^\^Npi^M^M^\^N^^'>                                                                                                                                                                     
 " :w^M'Ti%run ^\^N"#pi^Mlocals().update(main())^M^\^N^^  

" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vimrc

" function! My_Backup(timer) abort
"         silent! write! /tmp/my_backup
" endfunction
