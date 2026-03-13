vim.lsp.enable('pyright')
vim.lsp.enable('bashls')
vim.lsp.enable('clangd')


vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method('textDocument/completion') then
            vim.opt.completeopt = { 'menuone', 'noselect', 'fuzzy', 'popup' }
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                underline = true,
            })
            -- manual trigger
            vim.keymap.set('i', '<C-Space>', function()
                vim.lsp.completion.get()
            end)
        end
    end,
})
