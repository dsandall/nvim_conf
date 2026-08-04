-- Decorated scrollbar: a thin gutter on the right edge marking diagnostics,
-- git hunks, search hits, marks and quickfix entries for the whole file.
return {
	"lewis6991/satellite.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		current_only = false,
		winblend = 0, -- edge's Visual is too close to Normal to survive blending
		zindex = 40,
		excluded_filetypes = {
			"neo-tree",
			"snacks_dashboard",
			"lazy",
			"mason",
			"help",
			"noice",
			"trouble",
		},
		handlers = {
			cursor = { enable = true },
			search = { enable = true },
			diagnostic = {
				enable = true,
				min_severity = vim.diagnostic.severity.HINT,
			},
			gitsigns = { enable = true },
			marks = { enable = true, show_builtins = false },
			quickfix = { enable = true },
		},
	},
	config = function(_, opts)
		require("satellite").setup(opts)

		-- SatelliteBar defaults to linking Visual, which edge renders nearly
		-- identical to Normal. Re-applied on every colorscheme change.
		local function set_hl()
			vim.api.nvim_set_hl(0, "SatelliteBar", { bg = "#5c6370" })
			vim.api.nvim_set_hl(0, "SatelliteCursor", { fg = "#a3be8c" })
		end
		set_hl()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })
	end,
	keys = {
		-- Plugin only ships :SatelliteEnable / :SatelliteDisable, so track state here.
		{
			"<leader>us",
			function()
				local on = vim.g.satellite_on
				if on == nil then
					on = true -- enabled on load
				end
				on = not on
				vim.g.satellite_on = on
				vim.cmd(on and "SatelliteEnable" or "SatelliteDisable")
			end,
			desc = "Toggle satellite scrollbar",
		},
	},
}
