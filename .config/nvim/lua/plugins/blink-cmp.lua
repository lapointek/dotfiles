return {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "enter",
            ["<C-Z>"] = { "accept", "fallback" },
        },
        appearance = { nerd_font_variant = 'mono' },
        completion = {
            menu = { auto_show = false },
            ghost_text = { enabled = true },
            accept = { auto_brackets = { enabled = true } },
            documentation = { auto_show = true },
        },
        signature = { enabled = true },
        sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
        fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
}
