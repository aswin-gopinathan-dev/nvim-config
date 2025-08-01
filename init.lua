
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then   -- if lazy.nvim doesnt exit in nvim-data folder, clone it from github
  vim.fn.system({
    "git", 
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", 
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath) -- add lazy nvim clone folder to runtime path


require("vim-options")
require("lazy").setup("plugins")
require("vim-keymaps-general")
require("vim-keymaps-build")
require("vim-keymaps-debug")



