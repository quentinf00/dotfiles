return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
  config = function()
    require "custom.telescope"
  end,
}
