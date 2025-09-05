return {
    {
        "mason-org/mason.nvim",
        opts = {},
    },

    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = {
                "basedpyright",
                "lua_ls",
                "clangd",
                "bashls",
                "ts_ls",
                "cssls",
                "html",
                "emmet_ls",
            },
        },
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                "stylua",
                "black",
                "shfmt",
                "ruff",
                "biome",
            },
            auto_update = false,
            run_on_start = true,
        },
    },

    {
        "neovim/nvim-lspconfig",
        config = function()
            local fzf_lua = require("fzf-lua")

            -- Fzf-lua LSP mappings
            vim.keymap.set('n', 'gd', fzf_lua.lsp_definitions, {
                noremap = true, silent = true, desc = 'Goto definition'
            })
            vim.keymap.set('n', 'gr', fzf_lua.lsp_references, {
                noremap = true, silent = true, desc = 'Goto references'
            })
            vim.keymap.set('n', 'gI', fzf_lua.lsp_implementations, {
                noremap = true, silent = true, desc = 'Goto implementation'
            })
            vim.keymap.set('n', '<leader>dt', fzf_lua.lsp_typedefs, {
                noremap = true, silent = true, desc = 'Type definition'
            })
            vim.keymap.set('n', '<leader>ds', fzf_lua.lsp_document_symbols, {
                noremap = true, silent = true, desc = 'Document symbols'
            })
            vim.keymap.set('n', '<leader>ws', fzf_lua.lsp_live_workspace_symbols, {
                noremap = true, silent = true, desc = 'Workspace symbols'
            })

            -- Native LSP mappings
            vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, {
                noremap = true, silent = true, desc = 'Rename'
            })
            vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, {
                noremap = true, silent = true, desc = 'Code action'
            })
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {
                noremap = true, silent = true, desc = 'Goto declaration'
            })

            -- Fix global variable vim for lua
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
                }
            }
        end,
    },
}
