return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = true,
  config = function()
    require "custom.telescope"
  end,
}
