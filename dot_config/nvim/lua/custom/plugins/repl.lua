return {
  {
  "dangooddd/pyrepl.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("pyrepl").setup({
      -- defaults (you can omit these):
      split_horizontal = false,
      split_ratio = 0.5,
      style = "default",
      image_width_ratio = 0.5,
      image_height_ratio = 0.5,
      block_pattern = "^# %%%%.*$",
      python_path = os.getenv("HOME") .. "/.pixi/envs/jupyterlab/bin/python",
      preferred_kernel = "python3",
    })

    vim.keymap.set("n", "<leader>jo", ":PyreplOpen<CR>", { silent = true })
    vim.keymap.set("n", "<leader>jh", ":PyreplHide<CR>", { silent = true })
    vim.keymap.set("n", "<leader>jc", ":PyreplClose<CR>", { silent = true })
    vim.keymap.set("n", "<leader>jb", ":PyreplSendBlock<CR>", { silent = true })
    vim.keymap.set("n", "<leader>jf", ":PyreplSendBuffer<CR>", { silent = true })
    vim.keymap.set("v", "<leader>jv", ":<C-u>PyreplSendVisual<CR>gv<Esc>", { silent = true })
    vim.keymap.set("n", "<leader>ji", ":PyreplOpenImages<CR>", { silent = true })
    vim.keymap.set("n", "<leader>js", ":PyreplInstall")
  end,
}
}
