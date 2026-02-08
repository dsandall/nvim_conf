-- Install lazy.nvim plugin manager

-- Edited to install lazypath under .config/nvim instead of .local
local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- points lazy at the lua/plugins directory
require("lazy").setup({ import = "plugins" })
