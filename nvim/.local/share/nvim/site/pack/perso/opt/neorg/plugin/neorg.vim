 lua << EOF

local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

-- These two are optional and provide syntax highlighting
-- for Neorg tables and the @document.meta tag
parser_configs.norg_meta = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
        files = { "src/parser.c" },
        branch = "main"
    },
}

parser_configs.norg_table = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
        files = { "src/parser.c" },
        branch = "main"
    },
}

require('neorg').setup {
   load = {
        ["core.defaults"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    work = "~/notes/work",
                    home = "~/notes/home",
                    gtd = "~/notes/gtd",
		    example_gtd = "~/example_workspaces/gtd",
                }
            }
        },
	["core.gtd.base"] = {
	   config = { -- Note that this table is optional and doesn't need to be provided
	       -- Configuration here
	       workspace = "gtd",
	       default_lists = {inbox = "inbox.norg"},
	       projects = {
			show_completed_projects = true,
			show_projects_without_tasks = true,
		}
	   }
	}
    }
}
 
EOF

nnoremap <leader>N :NeorgStart<CR>
nnoremap <leader>gw :Neorg workspace gtd<CR>
nnoremap <leader>gc :Neorg gtd capture<CR>
nnoremap <leader>gv :Neorg gtd views<CR>
nnoremap <leader>ge :Neorg gtd edit<CR>
