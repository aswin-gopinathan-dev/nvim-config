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
           
            default_component_configs = {
                git_status = {
                    symbols = {
                        -- Change type
                        added = "A",     -- or "✚"
                        modified = "M",  -- or ""
                        deleted = "D",   -- this can only be used in the git_status source
                        renamed = "R",   -- this can only be used in the git_status source
                        -- Status type
                        untracked = "U", --"",
                        ignored = "I",
                        unstaged = "US",
                        staged = "S",
                        conflict = "C",
                    },
                },
            },
            filesystem = {
                header = {
                    -- Set this to true to display only the project name
                    show_root_name = true,
                },
                filtered_items = {
                    visible = false,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_by_name = {
                        ".DS_Store",
                        ".git",
                        ".gitignore",
                        "README.md",
                        "build",
                        ".cache"
                    },
                    show_hidden_count = false,
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
