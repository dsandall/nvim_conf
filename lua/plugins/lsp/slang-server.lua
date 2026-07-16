vim.lsp.config("slang-server", {
	cmd = { "slang-server" },
	-- .slang first so a per-example config wins over the repo-wide .git root
	-- (otherwise slang indexes the whole repo + its duplicate build/out modules)
	root_markers = { ".slang", ".git" },
	filetypes = {
		"systemverilog",
		"verilog",
	},
})

vim.lsp.enable("slang-server")

return {}
