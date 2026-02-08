-- adding a new LSP to nvim is this easy!
-- install on system
-- set the cmd variable, set the filetypes
-- vim.lsp.enable()
vim.lsp.config("hyprls", {
	cmd = { "hyprls" },
	filetypes = { "hyprlang" },
	-- optional : "settings" is a table passed to the LSP
	--[[ 	settings = {
		hyprls = {
			preferIgnoreFile = true, -- set to false to prefer `hyprls.ignore`
			ignore = { "hyprlock.conf", "hypridle.conf" },
		},
	}, ]]
})

vim.lsp.enable("hyprls")

return {}
