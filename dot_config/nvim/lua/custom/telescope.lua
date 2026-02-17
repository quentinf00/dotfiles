local data = assert(vim.fn.stdpath "data") --[[@as string]]

require("telescope").setup {
  extensions = {
    fzf = {},
    wrap_results = true,
    history = {
      path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
      limit = 100,
    },
  },
}

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "smart_history")

local builtin = require "telescope.builtin"

vim.keymap.set("n", "<leader>tt", builtin.treesitter, { desc = "Telescope: Treesitter symbols" })
vim.keymap.set("n", "<leader>tf", function()
  builtin.treesitter { default_text = "function" }
end, { desc = "Telescope: Treesitter functions" })
vim.keymap.set("n", "<leader>fd", builtin.find_files, { desc = "Telescope: Find files" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope: Help tags" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope: Live grep" })
vim.keymap.set("n", "<leader>ff", builtin.buffers, { desc = "Telescope: Buffers" })
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Telescope: Buffer fuzzy find" })

vim.keymap.set("n", "<leader>gw", builtin.grep_string, { desc = "Telescope: Grep word under cursor" })

vim.keymap.set("n", "<space>fa", function()
  ---@diagnostic disable-next-line: param-type-mismatch
  builtin.find_files { cwd = vim.fs.joinpath(vim.fn.stdpath "data", "lazy") }
end, { desc = "Telescope: Find in plugins" })

vim.keymap.set("n", "<space>en", function()
  builtin.find_files { cwd = vim.fn.stdpath "config" }
end, { desc = "Telescope: Find in nvim config" })
