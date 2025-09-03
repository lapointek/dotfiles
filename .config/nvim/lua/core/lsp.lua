vim.lsp.enable('pyright')
vim.lsp.enable('bashls')
vim.lsp.enable('clangd')
vim.lsp.enable('lua_ls')

-- Show diagnostic on cursor hover
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, {
            focusable = false,
            close_events = {"BufLeave", "CursorMoved", "InsertEnter", "FocusLost"},
        })
    end
})


