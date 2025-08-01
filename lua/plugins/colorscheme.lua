return {
	"EdenEast/nightfox.nvim",
	dependencies = {
		"nvim-lualine/lualine.nvim",
		"nvim-tree/nvim-web-devicons",
		"catppuccin/nvim",
	},
   config = function()
     vim.cmd.colorscheme "dayfox"
	 
	 
	--require("catppuccin").setup(flavour="latte",)

	-- setup must be called before loading
	--vim.cmd.colorscheme "catppuccin-latte"
		
	require("catppuccin").setup({
		flavour = "latte", -- latte, frappe, macchiato, mocha
		
		transparent_background = false, -- disables setting the background color.	
		show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
		term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
		no_italic = true, -- Force no italic
		no_bold = false, -- Force no bold
		no_underline = false, -- Force no underline
		styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
			comments = { "italic" }, -- Change the style of comments
			conditionals = { "italic" },
			loops = {},
			functions = {},
			keywords = {},
			strings = {},
			variables = {},
			numbers = {},
			booleans = {},
			properties = {},
			types = {},
			operators = {},
			-- miscs = {}, -- Uncomment to turn off hard-coded styles
		},
		color_overrides = {},
		custom_highlights = function(colors)
			return 
			{
				LineNr = { fg = colors.sky },
				CursorLineNr = { fg = colors.lavender },
				CursorLine = { bg = colors.surface0 },
				
				Cursor = { fg = colors.blue },
			}
			end,
		default_integrations = true,
		integrations = {
			cmp = true,
			gitsigns = true,
			nvimtree = true,
			treesitter = true,
			notify = false,
			mini = {
				enabled = true,
				indentscope_color = "",
			},
			-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
		},
	})
	
	require('lualine').setup {
	options = {
		theme = "catppuccin"
	}
}

	-- setup must be called before loading
	vim.cmd.colorscheme "catppuccin"

   end,
}
