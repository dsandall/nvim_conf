-- disable netrw (no disrespect)
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

vim.g.mapleader = " "
vim.opt.number = true

-- NOTE: Order Matters!
-- Leader must be set prior
require("lazyvim")

vim.keymap.set("n", "<leader>dd", function()
	-- TODO: make gooder
	vim.diagnostic.goto_next()
	vim.lsp.buf.code_action()
end)
