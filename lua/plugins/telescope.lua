return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
		defaults = {
          layout_strategy = 'vertical', -- Ensure you are using horizontal layout
          layout_config = {
			width = 0.9,
		  },
        },
		pickers = {
  		  live_grep = {
		    additional_args = function()
			  return { "--fixed-strings" }
		    end,
		  },
	    },
      })


      require("telescope").load_extension("ui-select")
	  
    end,
  },
}
