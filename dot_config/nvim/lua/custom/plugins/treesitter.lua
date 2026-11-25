return {
  { "nvim-treesitter/nvim-treesitter-textobjects" },
   { -- Highlight, edit, and navigate code
     "nvim-treesitter/nvim-treesitter",
     build = ":TSUpdate",
     event = "BufReadPost",
     opts = {
       ensure_installed = { "bash", "python", "diff", "lua", "luadoc", "markdown", "vimdoc" },
     },
     config = function(_, opts)
       require("nvim-treesitter").setup(opts)
       require "custom.treesitter-textobjects"
     end,
  },
}
