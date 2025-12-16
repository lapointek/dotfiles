return {
  {
    "nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
        underline = false,
        severity_sort = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },
}
