-- disable netrw (no disrespect)
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

vim.g.mapleader = " "
vim.opt.number = true

------------------
-- NOTE: Order Matters!
-- Leader must be set prior
require("lazyvim")
-- Plugin Conf must be set after
-- NOTE: Order Matters!
------------------

-- -- using :FzfLua awesome_colorschemes instead
-- vim.o.background = "dark" -- or "light" for light mode
-- vim.cmd([[colorscheme gruvbox]])

require("nvim_lua_lsp")
