vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Disable treesitter highlight for latex
vim.api.nvim_create_autocmd("FileType", {
  pattern = "latex",
  callback = function()
    vim.treesitter.stop()
  end,
})

-- Textobjects config (select/move options)
require("nvim-treesitter-textobjects").setup {
  select = {
    lookahead = true,
    selection_modes = {
      ["@parameter.outer"] = "v",
      ["@function.outer"] = "V",
      ["@class.outer"] = "V",
    },
  },
  move = {
    set_jumps = true,
  },
}

-- Textobject select keymaps
local select = require "nvim-treesitter-textobjects.select"
vim.keymap.set({ "x", "o" }, "af", function()
  select.select_textobject "@function.outer"
end, { desc = "Select outer function" })
vim.keymap.set({ "x", "o" }, "if", function()
  select.select_textobject "@function.inner"
end, { desc = "Select inner function" })
vim.keymap.set({ "x", "o" }, "ac", function()
  select.select_textobject "@class.outer"
end, { desc = "Select outer class" })
vim.keymap.set({ "x", "o" }, "ic", function()
  select.select_textobject "@class.inner"
end, { desc = "Select inner class" })

-- Textobject move keymaps
local move = require "nvim-treesitter-textobjects.move"
vim.keymap.set({ "n", "x", "o" }, "àf", function()
  move.goto_next_start "@function.outer"
end, { desc = "Next function start" })
vim.keymap.set({ "n", "x", "o" }, "àc", function()
  move.goto_next_start "@class.outer"
end, { desc = "Next class start" })
vim.keymap.set({ "n", "x", "o" }, "às", function()
  move.goto_next_start("@scope", "locals")
end, { desc = "Next scope" })
vim.keymap.set({ "n", "x", "o" }, "çf", function()
  move.goto_previous_start "@function.outer"
end, { desc = "Previous function start" })
vim.keymap.set({ "n", "x", "o" }, "çc", function()
  move.goto_previous_start "@class.outer"
end, { desc = "Previous class start" })
vim.keymap.set({ "n", "x", "o" }, "àd", function()
  move.goto_next "@conditional.outer"
end, { desc = "Next conditional" })
vim.keymap.set({ "n", "x", "o" }, "çd", function()
  move.goto_previous "@conditional.outer"
end, { desc = "Previous conditional" })
