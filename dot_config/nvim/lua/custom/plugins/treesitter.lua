return {
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Ensure parsers are installed (no-op if already present)
      require("nvim-treesitter.install").install {
        "bash",
        "python",
        "diff",
        "lua",
        "luadoc",
        "markdown",
        "vimdoc",
      }

      require "custom.treesitter-textobjects"
    end,
  },
}
