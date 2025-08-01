return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
    },
	
	opts = {
		layouts = 
		{
			{
				elements = 
				{
					{ id = "scopes", size = 0.50 },
					--{ id = "breakpoints", size = 0.00 },
					--{ id = "stacks", size = 0.20 },
					{ id = "watches", size = 0.50 },
				},
				position = "left",
				size = 45,
			},
			{
				elements = 
				{
					{ id = "console", size = 0.5 },
					{ id = "repl", size = 0.5 },
				},
				position = "bottom",
				size = 8,
			},
			
		},
	},
	
  
    config = function(_, opts)
        local dap = require("dap")
        local dapui = require("dapui")

        dap.adapters.codelldb = {
          type = 'executable',
          command = '/home/aswin/.local/share/nvim/mason/bin/codelldb',
          name = 'codelldb'
        }
		
		local function read_debug_json()
		  local path = vim.fn.getcwd() .. "/debug.json"
		  local ok, json = pcall(vim.fn.readfile, path)
		  if not ok then
			error("Could not read debug.json")
		  end

		  local joined = table.concat(json, "\n")
		  local ok2, config = pcall(vim.fn.json_decode, joined)
		  if not ok2 then
			error("Invalid JSON in debug.json")
		  end

		  return config
		end

        dap.configurations.cpp = {
            {
                name = "Launch",
                type = "codelldb",
                request = "launch",
                --program = '/mnt/c/Users/aswin/Desktop/My Projects/3D/3dRenderer/3dRenderer_nvim/src/renderer',
				--[[program = function()
				  local current_file_dir = vim.fn.getcwd()
				  local exe = vim.fn.input('Path to executable: ', current_file_dir .. '/renderer', 'file')
				  print("Program: " .. exe)
				  return exe
				end,

				cwd = function()
				  print("CWD: " .. vim.fn.getcwd())
				  return vim.fn.getcwd()
				end,--]]
				program = function()
				  local cfg = read_debug_json()
				  return cfg.program
				end,

				cwd = function()
				  local cfg = read_debug_json()
				  return cfg.cwd
				end,
	
                stopOnEntry = false,
                args = {},
				
				runInTerminal = false,      -- launch in a real terminal
				console = "internalConsole", -- send output to terminal, not just internal pipe
            },
        }
 
		
		dapui.setup(opts)
		
		local nio = require("nio")
		nio.api.nvim_buf_set_name(dapui.elements.scopes.buffer(), "Locals")
		nio.api.nvim_buf_set_name(dapui.elements.stacks.buffer(), "Call Stack")
		nio.api.nvim_buf_set_name(dapui.elements.watches.buffer(), "Watch")
		nio.api.nvim_buf_set_name(dapui.elements.breakpoints.buffer(), "Breakpoints")
		nio.api.nvim_buf_set_name(dapui.elements.console.buffer(), "Console")
		
		vim.diagnostic.config({
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = " ", [vim.diagnostic.severity.WARN] = " ",
				[vim.diagnostic.severity.INFO] = " ", [vim.diagnostic.severity.HINT] = "󰠠 ",
			},
			linehl = {
				[vim.diagnostic.severity.ERROR] = "Error", [vim.diagnostic.severity.WARN] = "Warn",
				[vim.diagnostic.severity.INFO] = "Info", [vim.diagnostic.severity.HINT] = "Hint",
			},
		  },
		})
		
		vim.fn.sign_define("DapBreakpoint", { text = "🐞" })
		vim.fn.sign_define("DapStopped", { text = "" })

		dap.listeners.before.attach.dapui_config = function() dapui.open() end
		dap.listeners.before.launch.dapui_config = function() dapui.open() end
		dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
		dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

		
    end,
}
