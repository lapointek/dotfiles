require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- File Handling Options
-- Write the contents, if it has been modified
vim.opt.autoread = true
-- Write the contents before a command
vim.opt.autowrite = true
-- Make a backup before overwriting a file
vim.opt.backup = false
-- Make a backup before overwriting a file
vim.opt.writebackup = false
-- Whether to use swap files
vim.opt.swapfile = false
-- Enable persistent undo
vim.opt.undofile = true
-- Directory to store undo file
vim.opt.undodir = vim.fn.expand("~/.vim/nvim-undo")
vim.opt.undolevels = 10000
vim.opt.undoreload = 10000
-- Minimum numver of screen lines to keep above cursor
vim.opt.scrolloff = 10
-- Relative line numbers
vim.opt.relativenumber = true
-- Wrap text
vim.opt.wrap = false
