-- Super+arrow keys for window navigation (matches Hyprland)
vim.keymap.set("n", "<S-Left>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<S-Down>", "<C-w>j", { desc = "Go to bottom window" })
vim.keymap.set("n", "<S-Up>", "<C-w>k", { desc = "Go to top window" })
vim.keymap.set("n", "<S-Right>", "<C-w>l", { desc = "Go to right window" })

return {}
