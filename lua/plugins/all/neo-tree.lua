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
		-- cache: abs path -> { add = n, del = n } for uncommitted changes; nil = needs fetch
		local diff_stats_cache = nil
		local diff_stats_inflight = false
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

		local function fetch_diff_stats()
			if diff_stats_inflight then return end
			diff_stats_inflight = true
			vim.system(
				{ "git", "rev-parse", "--show-toplevel" },
				{ text = true },
				vim.schedule_wrap(function(root_result)
					local root = (root_result.stdout or ""):gsub("%s+$", "")
					if root_result.code ~= 0 or root == "" then
						diff_stats_inflight = false
						diff_stats_cache = {}
						return
					end
					vim.system(
						{ "git", "diff", "HEAD", "--numstat" },
						{ text = true, cwd = root },
						vim.schedule_wrap(function(result)
							diff_stats_inflight = false
							local stats = {}
							for line in (result.stdout or ""):gmatch("[^\n]+") do
								-- binary files show "-" for counts; skip them
								local add, del, file = line:match("^(%d+)\t(%d+)\t(.+)$")
								if add then
									-- renames appear as "old => new" or "dir/{old => new}/f"
									file = file:gsub("{.-=> (.-)}", "%1"):gsub("^.* => ", "")
									stats[root .. "/" .. file] = { add = tonumber(add), del = tonumber(del) }
								end
							end
							diff_stats_cache = stats
							schedule_refresh()
						end)
					)
				end)
			)
		end

		-- uncommitted changes invalidate the diff stats (saves, checkouts, external edits)
		vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained" }, {
			group = vim.api.nvim_create_augroup("NeoTreeDiffStats", { clear = true }),
			callback = function()
				diff_stats_cache = nil
				schedule_refresh()
			end,
		})

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
					git_diff_stats = function(_config, node, _state)
						if diff_stats_cache == nil then
							fetch_diff_stats()
							return {}
						end
						local path = node:get_id()
						local stats = diff_stats_cache[path]
						if not stats and node.type == "directory" then
							-- aggregate all changed files under this directory
							local add, del = 0, 0
							local prefix = path .. "/"
							for file, s in pairs(diff_stats_cache) do
								if file:sub(1, #prefix) == prefix then
									add, del = add + s.add, del + s.del
								end
							end
							if add > 0 or del > 0 then stats = { add = add, del = del } end
						end
						if not stats then return {} end
						return {
							{ text = "+" .. stats.add .. " ", highlight = "NeoTreeGitAdded" },
							{ text = "-" .. stats.del .. " ", highlight = "NeoTreeGitDeleted" },
						}
					end,
				},
				renderers = {
					file = {
						{ "indent" },
						{ "icon" },
						{ "filtered_by" },
						{ "name", use_git_status_colors = true },
						{ "git_status", highlight = "NeoTreeDimText" },
						{ "git_diff_stats" },
						{ "git_last_modified", highlight = "NeoTreeDimText" },
					},
					directory = {
						{ "indent" },
						{ "icon" },
						{ "filtered_by" },
						{ "name" },
						{ "git_diff_stats" },
						{ "git_last_modified", highlight = "NeoTreeDimText" },
					},
				},
			},
		})
	end,
}
