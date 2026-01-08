-- Rebind Shift + Arrow keys to switch windows
vim.api.nvim_set_keymap("n", "<S-Left>", ":wincmd h<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-Down>", ":wincmd j<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-Up>", ":wincmd k<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-Right>", ":wincmd l<CR>", { noremap = true, silent = true })
