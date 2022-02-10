lua <<EOF
require'nvim-treesitter.configs'.setup {

  textsubjects = {
        enable = true,
        prev_selection = ',', -- (Optional) keymap to select the previous selection
        keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
            ['i;'] = 'textsubjects-container-inner',
        },
  },
  textobjects = {
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["<leader>>f"] = "@function.outer",
        ["<leader>>c"] = "@class.outer",
      },
      goto_next_end = {
        ["<leader>>F"] = "@function.outer",
        ["<leader>>C"] = "@class.outer",
      },
      goto_previous_start = {
        ["<leader><f"] = "@function.outer",
        ["<leader><c"] = "@class.outer",
      },
      goto_previous_end = {
        ["<leader><F"] = "@function.outer",
        ["<leader><C"] = "@class.outer",
      },
    },
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    lsp_interop = {
      enable = true,
      border = 'none',
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
}

EOF
