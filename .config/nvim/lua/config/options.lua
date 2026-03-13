-- User Interface
vim.opt.number = true			                        -- Line Numbers
vim.opt.relativenumber = true	                        -- Relative line numbers
vim.opt.cursorline = true		                        -- Highlight current line
vim.opt.scrolloff = 10			                        -- Keep 10 lines above/below cursor
vim.opt.sidescrolloff = 8		                        -- Keep 8 columns left/right of cursor
vim.opt.laststatus = 2                                  -- Visibility of statusline
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.showtabline = 1

-- Visual Settings
vim.opt.termguicolors = true                            -- 24-bit RGB in the TUI
vim.opt.colorcolumn = "100"                             -- Show column
vim.opt.signcolumn = "yes"                              -- Show sign column
vim.opt.showmatch = true                                -- Highlight matching bracket
vim.opt.matchtime = 2                                   -- How long to show matching bracket
vim.opt.synmaxcol = 300                                 -- Syntax highlighting limit
vim.opt.diffopt:append("linematch:60")                  -- Diff behavior

-- Editing
vim.opt.wrap = false		                            -- Wrap long lines
vim.opt.tabstop = 2                                     -- Tab width
vim.opt.shiftwidth = 2                                  -- Indent width
vim.opt.softtabstop = 2                                 -- Soft tab stop
vim.opt.expandtab = true                                -- Use spaces instead of tabs
vim.opt.smartindent = true                              -- Smart auto-indenting
vim.opt.autoindent = true                               -- Copy indentation of the previous line
vim.opt.smarttab = true                                 -- Smart tab
vim.opt.backspace = { "start", "eol", "indent" }
              
-- Search
vim.opt.ignorecase = true 		                        -- Ignore case in search patterns
vim.opt.smartcase = true		                        -- Override ignorecase if search has uppercase
vim.opt.hlsearch = true			                        -- Highlight search matches
vim.opt.wrapscan = true			                        -- Wrap around end of file in searches
vim.opt.incsearch = true                                -- Incremental highlighting
vim.opt.inccommand = "split"                            -- Interactive live preview
             
-- Input and Completion
vim.opt.mouse = "a"                                     -- Mouse support
vim.opt.wildmenu = true                                 -- Command-line completion
vim.opt.wildmode = "longest:full,full"                  -- How completion behaves
vim.opt.showmode = false                                -- Don't show mode in command line
vim.opt.completeopt = "menu,noselect"                   -- Options for insert-mode completion
vim.opt.clipboard:append("unnamedplus")                 -- Use system clipboard
vim.opt.selection = "inclusive"                         -- Selection behavior
vim.opt.timeout = true
vim.opt.timeoutlen = 1000

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

-- Performance
vim.opt.redrawtime = 10000                              -- Time spent on redrawing the screen

