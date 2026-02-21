-- disable netrw (no disrespect)
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

-- space <leader>
vim.g.mapleader = " "

vim.opt.conceallevel = 2 -- needed for obsidian.nvim
vim.opt.number = true
vim.opt.relativenumber = true

-- LSP folding
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
-- don't fold on open
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- NOTE: Order Matters!
-- Leader must be set prior
require("lazyvim")

require("lsp_window_theme").setup()

vim.keymap.set("n", "<leader>dd", function()
	-- TODO: make gooder
	vim.diagnostic.goto_next()
	vim.lsp.buf.code_action()
end)
