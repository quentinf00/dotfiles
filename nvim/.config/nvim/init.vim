packadd! nvim-lspconfig
packadd! nvim-compe
" packadd! nvim-treesitter-textsubjects
" packadd! nvim-treesitter-textobjects

packadd! lsp
" packadd! ts

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

function! My_Backup(timer) abort
        silent! write! /tmp/my_backup
endfunction
