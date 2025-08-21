vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set clipboard=unnamedplus") 
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false
vim.opt.relativenumber = true -- shows line number relative to cursor position. used to jump lines
vim.opt.number = true -- shows absolute line number where the cursor is
vim.opt.cursorline = true -- highlight the cursor line
vim.wo.number = true
vim.o.whichwrap = "b,s,[,],h,l"
