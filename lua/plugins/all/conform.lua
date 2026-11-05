-- Auto formatting. Works with LSP
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		--[[ 	formatters_by_ft = {
			lua = { "stylua" },
		}, ]]
		formatters_by_ft = {
			tex = { "tex-fmt" },
			systemverilog = { "verible_verilog_format" },
			verilog = { "verible_verilog_format" },
		},
		-- tex is never formatted on save: tex-fmt isn't installed, so it fell through to
		-- texlab -> latexindent, which reindents against STYLE.md's line rules
		format_on_save = function(bufnr)
			if vim.bo[bufnr].filetype == "tex" then
				return
			end
			return { timeout_ms = 500, lsp_fallback = true }
		end,
	},
}
