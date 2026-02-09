-- Super+arrow keys for window navigation (matches Hyprland)
vim.keymap.set("n", "<S-Left>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<S-Down>", "<C-w>j", { desc = "Go to bottom window" })
vim.keymap.set("n", "<S-Up>", "<C-w>k", { desc = "Go to top window" })
vim.keymap.set("n", "<S-Right>", "<C-w>l", { desc = "Go to right window" })

local toggleInlay = function()
	local current_value = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
	vim.lsp.inlay_hint.enable(not current_value, { bufnr = 0 })
end

vim.keymap.set("n", "<leader>j", toggleInlay, { desc = "lsp inlay hints" })

return {}
