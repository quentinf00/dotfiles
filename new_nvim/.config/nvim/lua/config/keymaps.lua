-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

vim.keymap.set("n", "<leader>FF", require("telescope.builtin").find_files, {})
vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "²", ui.toggle_quick_menu)

vim.keymap.set("n", "&", function()
  ui.nav_file(1)
end)
vim.keymap.set("n", "é", function()
  ui.nav_file(2)
end)
vim.keymap.set("n", "ç", function()
  ui.nav_file(3)
end)
vim.keymap.set("n", "à", function()
  ui.nav_file(4)
end)
