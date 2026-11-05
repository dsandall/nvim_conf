return {
	"lervag/vimtex",
	lazy = false, -- we don't want to lazy load VimTeX
	-- tag = "v2.15", -- uncomment to pin to a specific release
	init = function()
		vim.g.vimtex_view_method = "zathura"
		-- warnings (overfull hbox etc.) stay in :copen instead of stealing a window
		vim.g.vimtex_quickfix_open_on_warning = 0
		-- show prose, not markup: \textbf{x} -> x, accents/math as glyphs. cursor line shows raw
		vim.g.vimtex_syntax_conceal = {
			accents = 1,
			ligatures = 1,
			cites = 1,
			fancy = 1,
			spacing = 1,
			greek = 1,
			math_bounds = 0,
			math_delimiters = 1,
			math_fracs = 1,
			math_super_sub = 1,
			math_symbols = 1,
			sections = 0,
			styles = 1,
		}
		vim.g.vimtex_syntax_conceal_cites = { type = "brackets", verbose = false }
	end,
}
