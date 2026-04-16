-- open neo-tree when opening a directory
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local arg = vim.fn.argv(0)
		if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
			vim.cmd("cd " .. vim.fn.argv(0))
			vim.cmd("Neotree show")
		end
	end,
})

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	lazy = false, -- necessary for my VimEnter autocommand to fire properly
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"echasnovski/mini.icons",
		"nvim-tree/nvim-web-devicons",
	},
	cmd = { "Neotree" },
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
	},
	config = function()
		-- cache: path -> date string, or false if not in git / untracked
		local git_date_cache = {}
		local refresh_timer = nil

		local function schedule_refresh()
			-- debounce: batch all async completions into one redraw
			if refresh_timer then
				refresh_timer:stop()
				refresh_timer:close()
			end
			refresh_timer = vim.defer_fn(function()
				refresh_timer = nil
				require("neo-tree.sources.manager").refresh("filesystem")
			end, 150)
		end

		require("neo-tree").setup({
			icon_provider = "mini.icons",
			filesystem = {
				follow_current_file = {
					enabled = true,
					leave_dirs_open = true,
				},
				use_libuv_file_watcher = true,
				components = {
					git_last_modified = function(config, node, _state)
						local path = node:get_id()
						local cached = git_date_cache[path]

						if cached == nil then
							-- mark in-flight to avoid duplicate jobs
							git_date_cache[path] = false
							vim.system(
								{ "git", "log", "-1", "--format=%cr", "--", path },
								{ text = true },
								vim.schedule_wrap(function(result)
									local date = (result.stdout or ""):gsub("%s+", "")
									git_date_cache[path] = date ~= "" and date or false
									if date ~= "" then schedule_refresh() end
								end)
							)
							return {}
						end

						if not cached then return {} end
						return { text = cached, highlight = config.highlight or "NeoTreeDimText" }
					end,
				},
				renderers = {
					file = {
						{ "indent" },
						{ "icon" },
						{ "filtered_by" },
						{ "name", use_git_status_colors = true },
						{ "git_status", highlight = "NeoTreeDimText" },
						{ "git_last_modified", highlight = "NeoTreeDimText" },
					},
					directory = {
						{ "indent" },
						{ "icon" },
						{ "filtered_by" },
						{ "name" },
						{ "git_last_modified", highlight = "NeoTreeDimText" },
					},
				},
			},
		})
	end,
}
