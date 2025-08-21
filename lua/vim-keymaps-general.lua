-- Refactored keymaps.lua with explicit which-key registration

local keymap = vim.keymap
local wk = require("which-key")

-- Telescope shortcuts --> Search functionality
local builtin = require("telescope.builtin")
keymap.set("n", "<leader>ff", builtin.find_files, {desc="Find Files"})
--keymap.set("n", "<leader>fs", builtin.live_grep, {desc="Find String"})
vim.keymap.set('n', '<leader>fs', function()
  require('telescope.builtin').live_grep({
    default_text = vim.fn.expand("<cword>")
  })
end, { desc = "Live grep with word under cursor" })

keymap.set("n", "<leader>fr", vim.lsp.buf.rename, {desc="Replace String"})
keymap.set("n", "<leader>fo", builtin.oldfiles, {desc="Recent Files"})
keymap.set("n", "<leader>ft", function()
  vim.lsp.buf.format({ formatting_options = { tabSize = 4, insertSpaces = true }})
end, {desc="Format File"})

vim.keymap.set("n", "<leader>fg", function()
  require("telescope.builtin").lsp_document_symbols({
    symbols = { "function", "method" } -- optional filter
  })
end, { desc = "Telescope: Show functions in file" })


vim.keymap.set("v", "<leader>fs", function()  -- Search selected text --> Press viw in normal to highlight the word under cursor
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getpos("."))
  local lines = vim.fn.getline(ls, le)
  if #lines == 0 then return end
  lines[#lines] = string.sub(lines[#lines], 1, ce)
  lines[1] = string.sub(lines[1], cs)
  local text = table.concat(lines, "\n")

  require("telescope.builtin").live_grep({
    default_text = text,
  })
end, { desc = "Live Grep Visual Selection" })

-- Window management
keymap.set("n", "<leader>wh", "<C-w>v")
keymap.set("n", "<leader>wv", "<C-w>s")
keymap.set("n", "<leader>we", "<C-w>=")
keymap.set("n", "<leader>wx", "<cmd>close<CR>")

-- Navigate windows panes
vim.keymap.set('n', '<leader>wn', function()
  local start_win = vim.api.nvim_get_current_win()
  local function is_neotree(win)
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    return bufname:match("neo%-tree")
  end

  vim.cmd("wincmd w")
  local curr_win = vim.api.nvim_get_current_win()

  while curr_win ~= start_win and is_neotree(curr_win) do
    vim.cmd("wincmd w")
    curr_win = vim.api.nvim_get_current_win()
  end
end, { desc = "Cycle windows" })


keymap.set('n', '<leader>r<Down>', ':resize +2<CR>')
keymap.set('n', '<leader>r<Up>', ':resize -2<CR>')
keymap.set('n', '<leader>r<Left>', ':vertical resize -2<CR>')
keymap.set('n', '<leader>r<Right>', ':vertical resize +2<CR>')

-- Common keys
keymap.set("n", "<leader>gp", "<C-o>")
keymap.set("n", "<leader>gn", "<C-i>")
keymap.set("n", "<leader>ge", "$")
keymap.set("n", "<leader>gs", "^")
keymap.set("n", "<leader>gS", "gg^")
keymap.set("n", "<leader>gE", "G$")
keymap.set('n', '<leader>hc', ':nohlsearch<CR>')

-- Barbar tab manager
keymap.set("n", "<leader>bp", "<Cmd>BufferPrevious<CR>")
keymap.set("n", "<leader>bn", "<Cmd>BufferNext<CR>")
keymap.set("n", "<leader>b1", "<Cmd>BufferGoto 1<CR>")
keymap.set("n", "<leader>b2", "<Cmd>BufferLast<CR>")
keymap.set("n", "<leader>bx", "<Cmd>BufferClose<CR>")
keymap.set("n", "<leader>bX", "<Cmd>BufferCloseAllButCurrent<CR>")
-- Next buffer
keymap.set("n", '<C-Tab>', ':bnext<CR>', { noremap = true, silent = true })
keymap.set("i", '<C-Tab>', '<Esc>:bnext<CR>', { noremap = true, silent = true })
-- Previous buffer
keymap.set("n", '<C-S-Tab>', ':bprevious<CR>', { noremap = true, silent = true })
keymap.set("i", '<C-S-Tab>', '<Esc>:bprevious<CR>', { noremap = true, silent = true })


-- Terminal logic
local function read_debug_json()
  local path = vim.fn.getcwd() .. "/debug.json"
  local ok, json = pcall(vim.fn.readfile, path)
  if not ok then return { program = "", cwd = "" } end
  local joined = table.concat(json, "\n")
  local ok2, config = pcall(vim.fn.json_decode, joined)
  if not ok2 then return { program = "", cwd = "" } end
  return config
end

local pgm = "'"..read_debug_json().program.."'"
local cwd = "'"..read_debug_json().cwd.."'"
local create_project = "~/.config/nvim/sh/project.sh"


local function close_quickfix()
  local wininfo = vim.fn.getwininfo()
  for _, win in ipairs(wininfo) do
    if win.quickfix == 1 then
      vim.cmd("cclose")
    end
  end
end

vim.keymap.set("n", "<leader>tf", function()
  close_quickfix()
  
  local cwd = vim.fn.getcwd()
  vim.cmd(string.format("ToggleTerm dir=%s direction='float'", cwd))
end, { desc = "Open ToggleTerm in current directory" })

vim.keymap.set("n", "<leader>tt", function()
  close_quickfix()
  
  local cwd = vim.fn.getcwd()
  vim.cmd(string.format("ToggleTerm dir=%s direction='horizontal'", cwd))
end, { desc = "Open ToggleTerm in current directory" })

keymap.set("t", "<leader>tt", "exit<CR>")

vim.keymap.set("n", "<leader>tb", function()
  local Terminal = require("toggleterm.terminal").Terminal
  local create_project = vim.fn.expand("~/.config/nvim/sh/build.sh")

  local term = Terminal:new({cmd = create_project, direction = "horizontal", close_on_exit = false, hidden = false, })

  term:toggle()
end)


vim.keymap.set("n", "<leader>tm", function()
  local Terminal = require("toggleterm.terminal").Terminal
  local create_misc_files = vim.fn.expand("~/.config/nvim/sh/misc.sh")

  local term = Terminal:new({cmd = create_misc_files, direction = "horizontal", close_on_exit = false, hidden = false, })

  term:toggle()
end)

vim.keymap.set("n", "<leader>tp", function()
  local Terminal = require("toggleterm.terminal").Terminal
  local create_project = vim.fn.expand("~/.config/nvim/sh/project.sh")

  local term = Terminal:new({cmd = create_project, direction = "horizontal", close_on_exit = true, hidden = false, })

  term:toggle()
  
  -- Wait a bit before refreshing Neo-tree and opening the file
  vim.defer_fn(function()
    local main_file = vim.fn.getcwd() .. "/src/main.cpp"
    if vim.fn.filereadable(main_file) == 1 then
      vim.cmd("edit " .. main_file)
      vim.cmd("Neotree reveal")
    end
  end, 300)
end)


-- close terminal
--vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>:ToggleTerm<CR>]], { desc = "Close ToggleTerm" })
-- Apply only in terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    -- Terminal mode mapping
    vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>:ToggleTerm<CR>]], {
      desc = "Close ToggleTerm",
      buffer = true
    })

    -- Normal mode mapping (inside terminal buffer)
    vim.keymap.set("n", "<Esc><Esc>", ":ToggleTerm<CR>", {
      desc = "Close ToggleTerm",
      buffer = true
    })
  end,
})


-- Escape Escape in normal mode: closes Quickfix if focused
vim.keymap.set("n", "<leader>cq", function()
  local buftype = vim.api.nvim_buf_get_option(0, "buftype")
  local filetype = vim.bo.filetype

  -- If it's the quickfix window
  if buftype == "quickfix" or filetype == "qf" then
    vim.cmd("cclose")
  end
end, { desc = "Close Quickfix" })

-- Neo-tree
keymap.set("n", "<leader>ee", ":Neotree toggle<CR>")
keymap.set("n", "<leader>ef", ":Neotree focus<CR>")
--keymap.set("n", "<leader>ex", ":Neotree close<CR>")
keymap.set("n", "<leader>ev", function()
    require("neo-tree.command").execute({
    source = "filesystem",
    toggle_hidden = true,
  })
end, { desc = "Neo-tree: Toggle hidden files" })


-- Auto Session
keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>")
keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>")
keymap.set("n", "<leader>wa", "<cmd>Autosession search<CR>")


-- LazyGit
keymap.set("n", "<leader>lg", ":LazyGit<CR>")
keymap.set("n", "<leader>lC", ":LazyGitConfig<CR>")
keymap.set("n", "<leader>lc", ":LazyGitCurrentFile<CR>")
keymap.set("n", "<leader>lf", ":LazyGitFilter<CR>")
keymap.set("n", "<leader>lF", ":LazyGitFilterCurrentFile<CR>")


-- Misc
-- Disable the following keymaps
local opts = { noremap = true, silent = true }
keymap.set("n", "s", "<Nop>", opts)
keymap.set("n", "c", "<Nop>", opts)
keymap.set("n", "r", "<Nop>", opts)
keymap.set("n", "gi", "<Nop>", opts)
keymap.set("n", "S", "<Nop>", opts)
keymap.set("n", "C", "<Nop>", opts)
keymap.set("n", "R", "<Nop>", opts)
keymap.set("n", "gI", "<Nop>", opts)

vim.keymap.set({ "n", "v" }, "<Up>", "v:count ? 'k' : 'gk'", { expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Down>", "v:count ? 'j' : 'gj'", { expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "<C-s>", ":w<CR>", { silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { silent = true })
vim.keymap.set({ "n", "v" }, "<C-x>", "<Cmd>qa<CR>", { silent = true })
vim.keymap.set("i", "<C-x>", "<Esc><Cmd>qa<CR>", { silent = true })
vim.keymap.set("t", "<C-x>", [[<C-\><C-n><Cmd>qa<CR>]], { silent = true })
vim.keymap.set({ "n", "v" }, "<C-X>", "<Cmd>qa!<CR>", { silent = true })
vim.keymap.set("i", "<C-X>", "<Esc><Cmd>qa!<CR>", { silent = true })
vim.keymap.set("t", "<C-X>", [[<C-\><C-n><Cmd>qa!<CR>]], { silent = true })



vim.keymap.set('i', '<A-Up>', '<Esc>viw', { desc = 'Insert→select inner word' })
vim.keymap.set('i', '<A-Left>', '<Esc>v0', { desc = 'Insert→BOL selection' })
vim.keymap.set('i', '<A-Right>', '<Esc>v$', { desc = 'Insert→EOL selection' })
vim.keymap.set('i', '<A-Down>', '<Esc>V',  { desc = 'Insert→Visual (line)' })




keymap.set("n", "<leader>?", function()
  require("which-key").show("<leader>")
end, { desc = "Show which-key popup" })

-- Which-Key registration

local wk = require('which-key')

local my_mappings = {
    -- Search
    { "<leader>f", name = "Find", icon = { icon = "󰈞", color = "orange" } },
    { "<leader>ff", desc = "Find Files" },
    { "<leader>fs", desc = "Find String" },
    { "<leader>fr", desc = "Replace String" },
    { "<leader>fo", desc = "Recent Files" },
    { "<leader>fR", desc = "Smart Rename" },
	{ "<leader>ft", desc = "Format File" },
    

    -- Buffer
    { "<leader>b", name = "Buffer", icon = { icon = "󰓩", color = "white" } },
    { "<leader>bp", desc = "Previous buffer" },
    { "<leader>bn", desc = "Next buffer" },
    { "<leader>b1", desc = "Go to first buffer" },
    { "<leader>b2", desc = "Go to last buffer" },
    { "<leader>bx", desc = "Close buffer" },
    { "<leader>bX", desc = "Close all but current buffer" },

    -- Window
    { "<leader>w", name = "Window", icon = { icon = "", color = "orange" } },
    { "<leader>wh", desc = "Horizontal split" },
    { "<leader>wv", desc = "Vertical split" },
    { "<leader>we", desc = "Equalize splits" },
    { "<leader>wx", desc = "Close window" },
    { "<leader>wn", desc = "Cycle windows" },

    -- Resize
	{ "<leader>r", name = "Resize", icon = { icon = "󰩨", color = "cyan" } },
    { "<leader>r<Down>", desc = "Resize height +2" },
    { "<leader>r<Up>", desc = "Resize height -2" },
    { "<leader>r<Left>", desc = "Resize width -2" },
    { "<leader>r<Right>", desc = "Resize width +2" },

    -- Navigation
    { "<leader>g", name = "Navigation", icon = { icon = "󱣱", color = "green" } },
    { "<leader>gp", desc = "Jump backward" },
	{ "<leader>gn", desc = "Jump forward" },
	{ "<leader>gs", desc = "Go to start of line" },
    { "<leader>ge", desc = "Go to end of line" },
    { "<leader>gS", desc = "Go to first line" },
    { "<leader>gE", desc = "Go to last line" },

    -- Terminal
    { "<leader>t", name = "Terminal", icon = { icon = "", color = "blue" } },
    { "<leader>tf", desc = "Open Floating Terminal" },
    { "<leader>tt", desc = "Open Horizontal Terminal" },
    { "<leader>tb", desc = "Build Template" },
    { "<leader>tp", desc = "Project Template" },

    -- File Explorer
    { "<leader>e", name = "Explorer", icon = { icon = "", color = "yellow" } },
    { "<leader>ee", desc = "Toggle Explorer" },
    { "<leader>ef", desc = "Focus Explorer" },

    -- Session
    { "<leader>s", name = "Session", icon = { icon = "", color = "blue" } },
    { "<leader>sr", desc = "Restore Session" },
    { "<leader>ss", desc = "Save Session" },
    { "<leader>sa", desc = "Search Sessions" },
	
	-- LazyGit
    { "<leader>l", name = "LazyGit", icon = { icon = "", color = "black" } },
    { "<leader>lg", desc = "Launch LazyGit" },
    { "<leader>lC", desc = "LazyGit Config" },
	{ "<leader>lc", desc = "LazyGit Current File" },
	{ "<leader>lf", desc = "LazyGit Filter" },
	{ "<leader>lF", desc = "LazyGit Filter Current File" },
	
	{ "<leader>?", desc = "Launch which-key", hidden=true },
}

wk.add(my_mappings)
