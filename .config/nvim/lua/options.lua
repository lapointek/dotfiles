require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- File Handling Options
vim.opt.autoread = true                                 -- Write the contents, if it has been modified
vim.opt.autowrite = true                                -- Write the contents before a command
vim.opt.backup = false                                  -- Make a backup before overwriting a file
vim.opt.writebackup = false                             -- Make a backup before overwriting a file
vim.opt.swapfile = false                                -- Whether to use swap files
vim.opt.undofile = true                                 -- Enable persistent undo
vim.opt.undodir = vim.fn.expand("~/.vim/nvim-undo")     -- Directory to store undo file
vim.opt.undolevels = 10000
vim.opt.undoreload = 10000
