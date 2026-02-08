vim.lsp.config("slang-server", {
	cmd = { "slang-server" },
	root_markers = { ".git", ".slang" },
	filetypes = {
		"systemverilog",
		"verilog",
	},
})

vim.lsp.enable("slang-server")

return {}
