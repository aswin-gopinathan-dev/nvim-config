local keymap = vim.keymap

-- Debugger
keymap.set('n', '<F5>', function() require('neo-tree').close_all(); require('dap').continue() end)
keymap.set('n', '<F10>', function() require('dap').step_over() end)
keymap.set('n', '<F11>', function() require('dap').step_into() end)
keymap.set('n', '<leader><F10>', function() require('dap').step_out() end)
keymap.set('n', '<F9>', function() require('dap').toggle_breakpoint() end)
keymap.set('n', '<leader><F9>', function() require('dap').set_breakpoint() end)
keymap.set('n', '<leader><F5>', function()
  require'dap'.disconnect({ terminateDebuggee = true })
  require'dap'.close()
  require'dapui'.close()
  --require('neo-tree').open_all()
end)

local keymap = vim.keymap

local function get_visual_selection_exact()
  -- save/restore a scratch register (z)
  local save, savetype = vim.fn.getreg('z'), vim.fn.getregtype('z')
  vim.cmd([[silent noautocmd normal! "zy]])   -- yank current visual selection to register z
  local text = vim.fn.getreg('z')
  vim.fn.setreg('z', save, savetype)          -- restore register z
  return text
end

keymap.set('v', '<leader>dw', function()
  local expr = get_visual_selection_exact()
    :gsub("^%s+", "")
    :gsub("%s+$", "")
    :gsub("\n+", " ")

  if expr ~= "" then
    local ok, err = pcall(function()
      require('dapui').elements.watches.add(expr)
    end)
    if not ok then
      vim.notify("Failed to add watch: " .. tostring(err), vim.log.levels.WARN)
    end
  else
    vim.notify("No valid selection to watch", vim.log.levels.INFO)
  end

  -- Exit visual mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { desc = "DAP UI: add watch from visual selection", silent = true })


keymap.set('n', '<leader>dw', function() require('dapui').elements.watches.add(vim.fn.expand('<cword>')) end)
keymap.set('n', '<leader>ds', function() require("dapui").float_element("stacks", {width=70,height=20,enter=true}) end)
keymap.set('n', '<leader>db', function() require("dapui").float_element("breakpoints", {width=70,height=20,enter=true}) end)


local wk = require('which-key')

local my_mappings = {
    -- Debugger
    { "<leader>d", name = "Debug", icon = { icon = "", color = "red" }},
    { "<F5>", desc = "Start Debugging" },
    { "<F9>", desc = "Toggle Breakpoint" },
    { "<F10>", desc = "Step Over" },
    { "<F11>", desc = "Step Into" },
    { "<leader><F5>", desc = "Stop Debugging", hidden=true },
    { "<leader><F9>", desc = "Set Breakpoint", hidden=true },
    { "<leader><F10>", desc = "Step Out", hidden=true },
    { "<leader>dw", desc = "Add Watch" },
    { "<leader>ds", desc = "Stack Trace" },
    { "<leader>db", desc = "Breakpoints" },

    -- LSP
    { "<leader>g", name = "LSP", icon = { icon = "󰒋", color = "green" } },
    { "<leader>gr", desc = "Show All References" },
    { "<leader>gD", desc = "Go to Declaration" },
    { "<leader>gd", desc = "Go to Definitions" },
    { "<leader>gk", desc = "Show Documentation" },
    { "<leader>ga", desc = "Code Actions" },

    -- Diagnostics
	{ "<leader>h", name = "Diagnostics", icon = { icon = "󰞋", color = "cyan" } },
    { "<leader>hD", desc = "Show Buffer Diagnostics" },
    { "<leader>hd", desc = "Show Line Diagnostics" },
    { "<leader>hp", desc = "Previous Diagnostic" },
    { "<leader>hn", desc = "Next Diagnostic" },
	{ "<leader>hc", desc = "Clear search highlight" },
}

wk.add(my_mappings)



-- LSP Shortcuts
local M = {}
function M.MapLspKeys(ev)
  local opts = { buffer = ev.buf, silent = true }
  keymap.set("n", "<leader>gr", "<cmd>Telescope lsp_references<CR>", vim.tbl_extend("force", opts, {desc="Show all references"}))
  keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, {desc="Go to declaration"}))
  keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_definitions<CR>", vim.tbl_extend("force", opts, {desc="Go to definitions"}))
  keymap.set({"n", "v"}, "<leader>ga", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, {desc="See available code actions"}))
  keymap.set("n", "<leader>fr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, {desc="Smart rename"}))
  keymap.set("n", "<leader>dD", "<cmd>Telescope diagnostics bufnr=0<CR>", vim.tbl_extend("force", opts, {desc="Show buffer diagnostics"}))
  keymap.set("n", "<leader>dd", vim.diagnostic.open_float, vim.tbl_extend("force", opts, {desc="Show line diagnostics"}))
  keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, {desc="Go to previous diagnostic"}))
  keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, {desc="Go to next diagnostic"}))
  keymap.set("n", "<leader>gk", function()
        vim.lsp.buf.hover({
            border = 'rounded',
        })
    end, vim.tbl_extend("force", opts, {desc="Show documentation"}))
end

return M
