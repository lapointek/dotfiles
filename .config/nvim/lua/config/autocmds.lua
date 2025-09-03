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
