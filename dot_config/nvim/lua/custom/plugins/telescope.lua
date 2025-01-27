return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
  config = function()
    require "custom.telescope"
  end,
}
