-- User Interface
-- Line Numbers
vim.opt.number = true
-- Relative line numbers
vim.opt.relativenumber = true
-- Highlight current line
vim.opt.cursorline = true
-- Keep lines above/below cursor
vim.opt.scrolloff = 5
-- Keep columns left/right of cursor
vim.opt.sidescrolloff = 5
-- Visibility of statusline
vim.opt.laststatus = 2
-- Split right
vim.opt.splitright = true
-- Split below
vim.opt.splitbelow = true
-- Display tab line when more than one tab page
vim.opt.showtabline = 1

-- Visual Settings
-- 24-bit RGB in the TUI
vim.opt.termguicolors = true
-- Show column
vim.opt.colorcolumn = "100"
-- Show sign column
vim.opt.signcolumn = "yes"
-- Highlight matching bracket
vim.opt.showmatch = true
-- How long to show matching bracket
vim.opt.matchtime = 2
-- Syntax highlighting limit
vim.opt.synmaxcol = 300
-- Diff behavior
vim.opt.diffopt:append("linematch:60")
-- Display trailing spaces
vim.opt.list = true
-- Enable soft wrapping
vim.opt.wrap = true
-- Wrap at word boundary
vim.opt.linebreak = true
-- Indents the continuation lines visually
vim.opt.breakindent = true
-- Show marker at start of wrapped line
vim.opt.showbreak = "↪ "
-- Define characters for trailing spaces
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
-- Cursor setting
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"

-- Editing
-- Tab width
vim.opt.tabstop = 4
-- Indent width
vim.opt.shiftwidth = 4
-- Soft tab stop
vim.opt.softtabstop = 4
-- Use spaces instead of tabs
vim.opt.expandtab = true
-- Smart auto-indenting
vim.opt.smartindent = true
-- Copy indentation of the previous line
vim.opt.autoindent = true
-- Smart tab
vim.opt.smarttab = true
-- Make backspace behave naturally
vim.opt.backspace = { "start", "eol", "indent" }

-- Search
-- Ignore case in search patterns
vim.opt.ignorecase = true
-- Override ignorecase if search has uppercase
vim.opt.smartcase = true
-- Highlight search matches
vim.opt.hlsearch = true
-- Wrap around end of file in searches
vim.opt.wrapscan = true
-- Incremental highlighting
vim.opt.incsearch = true
-- Interactive live preview
vim.opt.inccommand = "split"

-- Input and Completion
-- Mouse support
vim.opt.mouse = "a"
-- Command-line completion
vim.opt.wildmenu = true
-- How completion behaves
vim.opt.wildmode = "longest:full,full"
-- Don't show mode in command line
vim.opt.showmode = false
-- Options for insert-mode completion
vim.opt.completeopt = "menu,noselect"
-- Use system clipboard
vim.opt.clipboard:append("unnamedplus")
-- Selection behavior
vim.opt.selection = "inclusive"
-- Enable timeout
vim.opt.timeout = true
-- Duration of timeouts for key mappings
vim.opt.timeoutlen = 1000
-- How frequent certain events are triggered
vim.opt.updatetime = 1000
-- Enable Spell checking
vim.opt.spell = true
-- Spell checking languages
vim.opt.spelllang = { "en_us", "en_gb" }
-- Case-insensitive tab completion in commands
vim.opt.wildignorecase = true

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
-- Number of undo levels (default is 1000)
vim.opt.undolevels = 10000
-- Max lines to save for undos when reloading a buffer
vim.opt.undoreload = 10000

-- Performance
vim.opt.redrawtime = 10000

-- Create undo directory if it doesn't exist
local undodir = vim.fn.expand("~/.vim/nvim-undo")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
