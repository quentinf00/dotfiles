packadd! nvim-lspconfig
packadd! nvim-compe

packadd! lsp

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
