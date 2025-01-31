local jump2d = require "mini.jump2d"
local jump_line_start = jump2d.builtin_opts.line_start
jump2d.setup {
  spotter = jump_line_start.spotter,
  hooks = { after_jump = jump_line_start.hooks.after_jump },
  mappings = { start_jumping = "ù" },
}
require("mini.surround").setup()
-- require("mini.jump2d").setup { spotter = MiniJump2d.builtin_opts.line_start }
require("mini.indentscope").setup()
require("mini.ai").setup()
