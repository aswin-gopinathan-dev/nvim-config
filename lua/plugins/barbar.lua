return
  {'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
	  'stevearc/resession.nvim',
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      animation = true,
	  --preset = 'default',
    },
	
  }