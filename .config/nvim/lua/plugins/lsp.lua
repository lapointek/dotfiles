return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        -- LSP servers
        ensure_installed = { "lua_ls", "basedpyright", "clangd", "bashls", },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
        {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            opts = {
                -- Formatters
                ensure_installed = { "stylua", "clang-format", "ruff", "shfmt", },
            },
        },
    },
    config = function()
        -- Diagnostic Config
        vim.diagnostic.config {
            severity_sort = true,
            float = { border = 'rounded', source = 'if_many' },
            underline = { severity = vim.diagnostic.severity.ERROR },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = '󰅚 ',
                    [vim.diagnostic.severity.WARN] = '󰀪 ',
                    [vim.diagnostic.severity.INFO] = '󰋽 ',
                    [vim.diagnostic.severity.HINT] = '󰌶 ',
                },
            },
            virtual_text = {
                source = 'if_many',
                spacing = 2,
                format = function(diagnostic)
                    local diagnostic_message = {
                        --[vim.diagnostic.severity.ERROR] = diagnostic.message,
                        --[vim.diagnostic.severity.WARN] = diagnostic.message,
                        --[vim.diagnostic.severity.INFO] = diagnostic.message,
                        --[vim.diagnostic.severity.HINT] = diagnostic.message,
                    }
                    return diagnostic_message[diagnostic.severity]
                end,
            },
        }

        local fzf_lua = require("fzf-lua")
        -- fzf-lua LSP mappings
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
