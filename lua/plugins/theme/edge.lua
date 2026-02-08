return {
	"sainnhe/edge",
	lazy = false, -- load during startup
	priority = 1000, -- load before other plugins
	config = function()
		-- Optional: configure edge style before loading
		-- vim.g.edge_style = 'aura'  -- options: 'default', 'aura', 'neon'
		-- vim.g.edge_enable_italic = 1
		-- vim.g.edge_disable_italic_comment = 1

		vim.cmd([[colorscheme edge]])
	end,
}
