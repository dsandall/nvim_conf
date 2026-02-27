-- Auto formatting. Works with LSP
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		--[[ 	formatters_by_ft = {
			lua = { "stylua" },
		}, ]]
		formatters_by_ft = { tex = { "tex-fmt" }, },
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
}
