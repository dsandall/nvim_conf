-- Verible language server: style-lint diagnostics + document symbols.
-- Complements slang-server (semantic/elaboration) — the two run side by side
-- and Neovim merges their diagnostics. Formatting is handled by conform
-- (verible_verilog_format), not here.
vim.lsp.config("verible", {
	cmd = {
		"verible-verilog-ls",
		-- pick up a project-local .rules.verible_lint by walking up the tree
		"--rules_config_search",
	},
	root_markers = { ".rules.verible_lint", ".slang", ".git" },
	filetypes = {
		"systemverilog",
		"verilog",
	},
})

vim.lsp.enable("verible")

return {}
