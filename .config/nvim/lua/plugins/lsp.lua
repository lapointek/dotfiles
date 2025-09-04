return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        -- LSP servers
        ensure_installed = { "lua_ls", "basedpyright", "clangd", "bashls", "typescript-language-server", "emmet-language-server", "html-lsp", "css-lsp" },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
        {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            opts = {
                -- Formatters
                ensure_installed = { "stylua", "clang-format", "ruff", "shfmt", "biome" },
            },
        },
    },
    config = function()
        -- fzf-lua LSP mappings
        local fzf_lua = require("fzf-lua")
        -- Goto definition
        vim.keymap.set('n', 'gd', fzf_lua.lsp_definitions, {
            noremap = true,
            silent = true,
            desc = 'Goto definition'
        })
        -- Goto Reference
        vim.keymap.set('n', 'gr', fzf_lua.lsp_references, {
            noremap = true,
            silent = true,
            desc = 'Goto references'
        })
        -- Goto Implmentation
        vim.keymap.set('n', 'gI', fzf_lua.lsp_implementations, {
            noremap = true,
            silent = true,
            desc = 'Goto implementation'
        })
        -- Type Defintion
        vim.keymap.set('n', '<leader>dt', fzf_lua.lsp_typedefs, {
            noremap = true,
            silent = true,
            desc = 'Type definition'
        })
        -- Document Symbols
        vim.keymap.set('n', '<leader>ds', fzf_lua.lsp_document_symbols, {
            noremap = true,
            silent = true,
            desc = 'Document symbols'
        })
        -- Workspace Symbols
        vim.keymap.set('n', '<leader>ws', fzf_lua.lsp_live_workspace_symbols, {
            noremap = true,
            silent = true,
            desc = 'Workspace symbols'
        })

        -- Native LSP mappings
        -- Rename
        vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, {
            noremap = true,
            silent = true,
            desc = 'Rename'
        })
        -- Code Action
        vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, {
            noremap = true,
            silent = true,
            desc = 'Code action'
        })
        -- Goto Declaration
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {
            noremap = true,
            silent = true,
            desc = 'Goto declaration'
        })
        -- Setup lua_ls
        require('lspconfig').lua_ls.setup {
            settings = {
                Lua = {
                    runtime = { version = 'LuaJIT' },
                    diagnostics = {
                        globals = { 'vim', 'require' },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    telemetry = { enable = false },
                },
            },
        }
    end,
}
