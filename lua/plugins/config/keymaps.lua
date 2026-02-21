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

vim.keymap.set("n", "<leader>w", "<C-w>", { desc = "Window commands" })

-- LSP Jump to Diagnostics
vim.keymap.set("n", "<leader>dd", function()
	vim.diagnostic.jump({ count = 1, float = true }) -- go to next diagnostic, in floating win
	-- vim.lsp.buf.code_action()
end)
vim.keymap.set("n", "<leader>da", function()
	vim.diagnostic.jump({ count = 1, float = false })
	vim.lsp.buf.code_action()
end)

--[[
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Go to bottom window" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Go to top window" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Go to right window" })
vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>wc", "<C-w>c", { desc = "Close window" })
vim.keymap.set("n", "<leader>wo", "<C-w>o", { desc = "Close other windows" })
vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "Equalize window sizes" })
vim.keymap.set("n", "<leader>w+", "<C-w>+", { desc = "Increase window height" })
vim.keymap.set("n", "<leader>w-", "<C-w>-", { desc = "Decrease window height" })
vim.keymap.set("n", "<leader>w>", "<C-w>>", { desc = "Increase window width" })
vim.keymap.set("n", "<leader>w<", "<C-w><", { desc = "Decrease window width" })
vim.keymap.set("n", "<leader>w_", "<C-w>_", { desc = "Maximize window height" })
vim.keymap.set("n", "<leader>w|", "<C-w>|", { desc = "Maximize window width" })
 ]]
return {}
