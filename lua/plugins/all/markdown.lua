-- markview.nvim: rich in-buffer markdown rendering while editing.
return {
	{
		"OXY2DEV/markview.nvim",
		-- author's recommendation: don't lazy-load (it defers internally);
		-- must load after the colorscheme for correct highlight groups
		lazy = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"echasnovski/mini.icons",
		},
		keys = {
			{ "<leader>mr", "<cmd>Markview Toggle<cr>", desc = "Markdown: toggle render" },
			{ "<leader>mp", "<cmd>Markview splitToggle<cr>", desc = "Markdown: split preview" },
			{ "<leader>mh", "<cmd>Markview HybridToggle<cr>", desc = "Markdown: toggle hybrid mode" },
		},
		opts = {
			preview = {
				icon_provider = "mini",
				filetypes = { "markdown", "quarto", "rmd" },
				modes = { "n", "no", "c" },
				-- show raw markdown around the cursor while inserting,
				-- same feel as render-markdown's anti_conceal above/below = 1
				hybrid_modes = { "i" },
				linewise_hybrid_mode = true,
				edit_range = { 1, 1 },
			},
		},
	},
}
