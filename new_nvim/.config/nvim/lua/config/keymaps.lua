-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

vim.keymap.set("n", "<leader>FF", require("telescope.builtin").find_files, {})
vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })