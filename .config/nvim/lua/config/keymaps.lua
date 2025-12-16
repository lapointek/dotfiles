-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Enter normal mode with "jj"
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false, desc = "Exit normal mode" })

-- Move line down and up in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

-- Delete without copying
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Del without copying" })

-- Delete line without affecting line break and copying
vim.keymap.set({ "n", "v" }, "<leader>D", [["_D]], { desc = "Del without affecting break and copying" })

-- Prevent deleted character from copying to clipboard
vim.keymap.set("n", "x", '"_x')
