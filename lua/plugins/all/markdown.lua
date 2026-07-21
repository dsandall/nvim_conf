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
				-- markview only renders in modes listed here; anything else
				-- reverts the WHOLE window to raw source. Visual modes must be
				-- present or selecting text unrenders the entire buffer. The
				-- codes are the raw vim.fn.mode() strings (markview does no
				-- normalization): "v" charwise, "V" linewise, "\22" = <C-v>.
				modes = { "n", "no", "c", "v", "V", "\22" },
				-- Subset of `modes` that reveals raw source only around the
				-- cursor (bounded by edit_range below) instead of unrendering.
				-- Same feel as render-markdown's anti_conceal above/below = 1.
				-- A mode must be in BOTH `modes` and here to get hybrid; "i"
				-- alone (not in modes) previously did nothing.
				hybrid_modes = { "i", "v", "V", "\22" },
				linewise_hybrid_mode = true,
				edit_range = { 1, 1 },
			},
			markdown = {
				-- Wide tables (6 cols, lots of inline `code`/**bold**/links) blow
				-- past the window; markview's decorative ╭──┬──╮ border row is
				-- computed at full table width and overshoots/jogs. Drop the
				-- decorator so only the column separators render.
				tables = {
					block_decorator = false,
					-- Default table hl links every border/separator to bright
					-- groups (MarkviewTableHeader -> @markup.heading, and
					-- MarkviewTableBorder -> MarkviewPalette5Fg). Route the whole
					-- table structure through a dim group so the column bars and
					-- alignment markers read as quiet chrome, not decoration.
					-- (markview's top-level `highlight_groups` opt is declared but
					-- unused in this version, so override here instead.)
					hl = {
						top = { "Comment", "Comment", "Comment", "Comment" },
						header = { "Comment", "Comment", "Comment" },
						separator = { "Comment", "Comment", "Comment", "Comment" },
						row = { "Comment", "Comment", "Comment" },
						bottom = { "Comment", "Comment", "Comment", "Comment" },
						overlap = { "Comment", "Comment", "Comment", "Comment" },
						align_left = "Comment",
						align_right = "Comment",
						align_center = { "Comment", "Comment" },
					},
				},
			},
		},
	},
}
