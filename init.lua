-- Rebind Shift + Arrow keys to switch windows
vim.api.nvim_set_keymap("n", "<S-Left>", ":wincmd h<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-Down>", ":wincmd j<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-Up>", ":wincmd k<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-Right>", ":wincmd l<CR>", { noremap = true, silent = true })

-- bootstrap lazy.nvim, LazyVim and your plugins
-- require() starts in your nvim/lua/ directory
require("config.lazy")         -- /nvim/lua/config/lazy.lua
require("osc52_ssh_clipboard") -- /nvim/lua/osc52_ssh_clipboard.lua
