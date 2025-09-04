return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
        {
            "<leader>ff",
            function() require("fzf-lua").files() end,
            desc = "Find files in current working directory",
        },
        {
            "<leader>fc",
            function() require("fzf-lua").files({ cwd = vim.fn.stdpath("config") }) end,
            desc = "Find in neovim config directory",
        },
        {
            "<leader>fz",
            function() require("fzf-lua").builtin() end,
            desc = "Find fzf-lua functions",
        },
        {
            "<leader>fg",
            function() require("fzf-lua").live_grep() end,
            desc = "Live grep",
        },
        {
            "<leader>fw",
            function() require("fzf-lua").grep_cword() end,
            desc = "Find current word",
        },
        {
            "<leader>fh",
            function() require("fzf-lua").helptags() end,
            desc = "Find help",
        },
        {
            "<leader>fk",
            function() require("fzf-lua").keymaps() end,
            desc = "Find keymaps",
        },
        {
            "<leader><leader>",
            function() require("fzf-lua").buffers() end,
            desc = "Search buffers",
        },
        {
            "<leader>fd",
            function() require("fzf-lua").diagnostics_document() end,
            desc = "Search diagnostics in current document",
        },
        {
            "<leader>fo",
            function() require("fzf-lua").oldfiles() end,
            desc = "Find old files",
        },
        {
            "<leader>/",
            function() require("fzf-lua").lgrep_curbuf() end,
            desc = "Live grep the current buffer",
        },
    }
}
