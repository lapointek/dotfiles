-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("YankHighlight", {
        clear = true }),
        pattern = "*",
        callback = function()
            vim.highlight.on_yank()
        end,
        desc = "Highlight yank",
    })

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("BufReadPost", {
        clear = true }),
        callback = function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            local lcount = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= lcount then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
        end,
    })

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
