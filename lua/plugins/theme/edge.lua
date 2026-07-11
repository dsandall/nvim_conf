return {
	"sainnhe/edge",
	lazy = false, -- load during startup
	priority = 1000, -- load before other plugins
	config = function()
		-- Optional: configure edge style before loading
		-- vim.g.edge_style = 'aura'  -- options: 'default', 'aura', 'neon'
		-- vim.g.edge_enable_italic = 1
		-- vim.g.edge_disable_italic_comment = 1

		-- set explicitly: nvim's terminal-background detection is async and
		-- lands after startup, so plugins that generate highlights at load
		-- time (markview etc.) would otherwise build wrong-mode palettes
		vim.o.background = "dark"

		vim.cmd([[colorscheme edge]])

		-- nvim only disables that detection at VimEnter, so a terminal
		-- reply arriving mid-startup still flips 'background'; delete the
		-- detection autocmd and re-assert in case the flip already happened
		vim.api.nvim_create_autocmd("VimEnter", {
			once = true,
			callback = function()
				for _, au in ipairs(vim.api.nvim_get_autocmds({ event = "TermResponse" })) do
					if (au.desc or ""):find("'background'", 1, true) then
						pcall(vim.api.nvim_del_autocmd, au.id)
					end
				end
				if vim.o.background ~= "dark" then
					vim.o.background = "dark"
				end
			end,
		})
	end,
}
