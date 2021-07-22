packadd! nvim-lspconfig
packadd! nvim-compe

packadd! nvim-treesitter

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
