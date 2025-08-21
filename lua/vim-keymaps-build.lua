local keymap = vim.keymap

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


-- Build, Display Errors, Traverse error list and jump to error in the code
-- Run make inside ToggleTerm AND capture output into Quickfix
keymap.set({"n", "i", "t"}, "<F7>", function()
  if vim.bo.buftype ~= "terminal" then
    vim.cmd("w")
  end
  local config = read_debug_json()
  local dir = config.cwd or vim.fn.getcwd()

  -- Run make and redirect output to a temp file
  local output_file = "/tmp/make_output.txt"
  local make_cmd = string.format("cd '%s' && make compile 2>&1 | tee %s", dir, output_file)

  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({
    dir = dir,
    direction = "horizontal",
    close_on_exit = true,
    hidden = false,
    count = 1,
  })

  if not term:is_open() then
    term:toggle()
  end
  term:send(make_cmd, false)

  -- Delay: parse the errors from output file after short timeout
  vim.defer_fn(function()
    local lines = vim.fn.readfile(output_file)
    vim.fn.setqflist({}, ' ', {
      title = 'Make Output',
      lines = lines,
      efm = "%f:%l:%c: %t%*[^:]: %m"
    })
  end, 1000) -- 1 sec delay
end, { desc = "Run make in ToggleTerm and capture errors" })

----------------------------------




-- F8 to run executable from debug.json
keymap.set("n", "<F8>", function()
  local config = read_debug_json()
  local dir = config.cwd or vim.fn.getcwd()
  local pgm = config.program or "./build/app"
  pgm = string.format('"%s"\n', pgm)

  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({
    dir = dir,
    direction = "horizontal",
    close_on_exit = true,
    hidden = false,
    count = 1,
  })

  term:toggle()
  term:send(pgm, false)
end, { desc = "Run program in ToggleTerm" })



vim.o.makeprg = "make"
vim.o.errorformat = "%f:%l:%c: %t%*[^:]: %m"


-- Traverse build error output list
vim.keymap.set({ "n", "t" }, "<leader>ce", function()
  local qf_list = vim.fn.getqflist()
  if vim.tbl_isempty(qf_list) then
    vim.notify("Quickfix list is empty", vim.log.levels.WARN)
    return
  end

  -- Try to move to next item safely
  local ok = pcall(vim.cmd, "cnext")
  if not ok then
    -- If at the end, wrap to the beginning
    vim.cmd("cfirst")
  end
end, { desc = "Next error (wrap around)" })


vim.keymap.set({ "n", "t" }, "<leader>cn", function()
   vim.cmd("cnext")
end)

vim.keymap.set({ "n", "t" }, "<leader>cp", function()
   vim.cmd("cprevious")
end)


-- Display build error output list
vim.keymap.set({"n", "t"}, "<leader>cc", function()
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({
    count = 1,
  })

  if term:is_open() then
    term:toggle()
  end
  
  local wininfo = vim.fn.getwininfo()
  for _, win in ipairs(wininfo) do
    if win.quickfix == 1 then
      vim.cmd("cclose")
      return
    end
  end
  vim.cmd("copen")

  -- Set quickfix window height before opening
  vim.o.cmdheight = 1
  vim.cmd("botright copen")
  vim.cmd("resize 10") -- explicitly set height
end, { desc = "Toggle Quickfix" })





keymap.set("n", "<F8>", function()
  local config = read_debug_json()
  local dir = config.cwd
  local pgm = config.program or ""
  pgm = string.format('"%s"', pgm)
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({ dir = dir, direction = "horizontal", close_on_exit = true, hidden = false, count = 1,})

  if not term:is_open() then
    term:toggle()
  end

  term:send(pgm)
end)

keymap.set("t", "<F8>", function()
  local config = read_debug_json()
  local pgm = config.program or ""
  if pgm == "" then return end
  
  pgm = string.format('"%s"', pgm)

  -- Simulate typing the program + Enter inside the terminal
  vim.api.nvim_feedkeys(pgm .. "\r", "t", false)
end)




local wk = require('which-key')

local my_mappings = {
    -- Build / Run
    { "<leader>c", name = "Compile", icon = { icon = "", color = "orange" } },
    { "<leader>cc", desc = "Show/Hide Error List" },
    { "<leader>ce", desc = "Go thru errors" },
    { "<leader>cn", desc = "Next Error" },
    { "<leader>cp", desc = "Previous Error" },
	{ "<leader>cq", desc = "Close" },

    -- Function keys
    { "<F7>", desc = "Build Project" },
    { "<F8>", desc = "Run Program" },

}

wk.add(my_mappings)

