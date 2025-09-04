-- User Interface
vim.opt.number = true         -- Line Numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.cursorline = true     -- Highlight current line
vim.opt.scrolloff = 5         -- Keep lines above/below cursor
vim.opt.sidescrolloff = 5     -- Keep columns left/right of cursor
vim.opt.laststatus = 2        -- Visibility of statusline
vim.opt.splitright = true     -- Split right
vim.opt.splitbelow = true     -- Split below
vim.opt.showtabline = 1       -- Display tab line when more than one tab page

-- Visual Settings
vim.opt.termguicolors = true -- 24-bit RGB in the TUI
vim.opt.colorcolumn = "100" -- Show column
vim.opt.signcolumn = "yes" -- Show sign column
vim.opt.showmatch = true -- Highlight matching bracket
vim.opt.matchtime = 2 -- How long to show matching bracket
vim.opt.synmaxcol = 300 -- Syntax highlighting limit
vim.opt.diffopt:append("linematch:60") -- Diff behavior
vim.opt.list = true -- Display trailing spaces
vim.opt.wrap = true -- Enable soft wrapping
vim.opt.linebreak = true -- Wrap at word boundaries
vim.opt.showbreak = '↪ ' -- Show marker at start of wrapped line
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- Define characters for trailing spaces

-- Editing
vim.opt.tabstop = 4                              -- Tab width
vim.opt.shiftwidth = 4                           -- Indent width
vim.opt.softtabstop = 4                          -- Soft tab stop
vim.opt.expandtab = true                         -- Use spaces instead of tabs
vim.opt.smartindent = true                       -- Smart auto-indenting
vim.opt.autoindent = true                        -- Copy indentation of the previous line
vim.opt.smarttab = true                          -- Smart tab
vim.opt.backspace = { "start", "eol", "indent" } -- Make backspace behave naturally

-- Search
vim.opt.ignorecase = true    -- Ignore case in search patterns
vim.opt.smartcase = true     -- Override ignorecase if search has uppercase
vim.opt.hlsearch = true      -- Highlight search matches
vim.opt.wrapscan = true      -- Wrap around end of file in searches
vim.opt.incsearch = true     -- Incremental highlighting
vim.opt.inccommand = "split" -- Interactive live preview

-- Input and Completion
vim.opt.mouse = "a"                      -- Mouse support
vim.opt.wildmenu = true                  -- Command-line completion
vim.opt.wildmode = "longest:full,full"   -- How completion behaves
vim.opt.showmode = false                 -- Don't show mode in command line
vim.opt.completeopt = "menu,noselect"    -- Options for insert-mode completion
vim.opt.clipboard:append("unnamedplus")  -- Use system clipboard
vim.opt.selection = "inclusive"          -- Selection behavior
vim.opt.timeout = true                   -- Enable timeout
vim.opt.timeoutlen = 1000                -- Duration of timeouts for key mappings
vim.opt.updatetime = 1000                -- How frequent certain events are triggered
vim.opt.spell = true                     -- Enable Spell checking
vim.opt.spelllang = { "en_us", "en_gb" } -- Spell checking languages
vim.opt.wildignorecase = true            -- Case-insensitive tab completion in commands

-- File Handling Options
vim.opt.autoread = true                             -- Write the contents, if it has been modified
vim.opt.autowrite = true                            -- Write the contents before a command
vim.opt.backup = false                              -- Make a backup before overwriting a file
vim.opt.writebackup = false                         -- Make a backup before overwriting a file
vim.opt.swapfile = false                            -- Whether to use swap files
vim.opt.undofile = true                             -- Enable persistent undo
vim.opt.undodir = vim.fn.expand("~/.vim/nvim-undo") -- Directory to store undo file

-- Performance
vim.opt.redrawtime = 10000

-- Create undo directory if it doesn't exist
local undodir = vim.fn.expand("~/.vim/nvim-undo")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end

-- Set GUI cursor on exit
local shape_group = vim.api.nvim_create_augroup("Shape", {
    clear = true })
vim.api.nvim_create_autocmd("VimLeave", {
    group = shape_group,
    callback = function()
        vim.opt.guicursor = "a:ver90-blinkon100-blinkoff100-blinkwait100"
    end,
})
