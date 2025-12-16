-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Write the contents before a command
vim.opt.autowrite = true
-- Write the contents, if it has been modified
vim.opt.autoread = true
-- Make a backup before overwriting a file
vim.opt.backup = false
-- Make a backup before overwriting a file
vim.opt.writebackup = true
-- Whether to use swap files
vim.opt.swapfile = true
-- Enable persistent undo
vim.opt.undofile = true
-- Directory to store undo file
vim.opt.undodir = vim.fn.expand("~/.vim/nvim-undo")
-- Number of undo levels (default is 1000)
vim.opt.undolevels = 10000
-- Max lines to save for undos when reloading a buffer
vim.opt.undoreload = 10000
-- Enable soft wrapping
vim.opt.wrap = true
-- Wrap at word boundary
vim.opt.linebreak = true
-- Indents the continuation lines visually
vim.opt.breakindent = true
-- Show marker at start of wrapped line
vim.opt.showbreak = "↪ "

-- Create undo directory if it doesn't exist
local undodir = vim.fn.expand("~/.vim/nvim-undo")
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
