vim.opt.foldmethod = "expr" -- treesiter time
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- treesiter

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup {
  ensure_installed = { "bash", "python", "diff", "lua", "luadoc", "markdown", "vimdoc" },
  -- Autoinstall languages that are not installed
  auto_install = true,
  highlight = { enable = true, disable = { "latex" } },
  indent = { enable = true, disable = { "python" } },
  textobjects = {
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["àf"] = "@function.outer",
        ["àc"] = { query = "@class.outer", desc = "Next class start" },
        ["às"] = {
          query = "@scope",
          query_group = "locals",
          desc = "Next scope",
        },
      },
      goto_previous_start = {
        ["çf"] = "@function.outer",
        ["çc"] = "@class.outer",
      },
      goto_next = { ["àd"] = "@conditional.outer" },
      goto_previous = { ["çd"] = "@conditional.outer" },
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V", -- linewise
        ["@class.outer"] = "V", -- blockwise
      },
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<space>i",
      scope_incremental = "<space>i",
      node_incremental = "<space>n",
      node_decremental = "<space>p",
    },
  },
}
