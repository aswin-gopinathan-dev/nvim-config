return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require('neo-tree').setup({
			sources = {
				'filesystem',
			},
            filesystem = {
				header = {
				  -- Set this to true to display only the project name
				  show_root_name = true, 
				},
                filtered_items = {
					visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_by_name = {
                        ".DS_Store",
                    },
                    never_show = {},
                },
				
            },
			window = {
				mappings = {
					["u"] = "navigate_up",
				},
			},			
        })

		vim.cmd("Neotree show")
    end,
}
