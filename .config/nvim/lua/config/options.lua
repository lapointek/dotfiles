-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.undofile = true
-- Directory to store undo file
vim.opt.undodir = vim.fn.expand("~/.vim/nvim-undo")
-- Number of undo levels (default is 1000)
vim.opt.undolevels = 10000
-- Max lines to save for undos when reloading a buffer
vim.opt.undoreload = 10000

-- Create undo directory if it doesn't exist
local undodir = vim.fn.expand("~/.vim/nvim-undo")
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
