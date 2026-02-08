return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- Get current theme info
		-- local current_theme = vim.g.colors_name
		-- print("Current colorscheme:", current_theme)

		require("lualine").setup({
			options = {
				-- icons_enabled = true,
				-- theme = "auto",
				-- component_separators = { left = "", right = "" },
				-- section_separators = { left = "", right = "" },
				-- disabled_filetypes = {
				-- 	statusline = {},
				-- 	winbar = {},
				-- },
				-- ignore_focus = {},
				-- always_divide_middle = true,
				-- always_show_tabline = true,
				globalstatus = true,
				-- refresh = {
				-- 	statusline = 1000,
				-- 	tabline = 1000,
				-- 	winbar = 1000,
				-- 	refresh_time = 16, -- ~60fps
				-- 	events = {
				-- 		"WinEnter",
				-- 		"BufEnter",
				-- 		"BufWritePost",
				-- 		"SessionLoadPost",
				-- 		"FileChangedShellPost",
				-- 		"VimResized",
				-- 		"Filetype",
				-- 		"CursorMoved",
				-- 		"CursorMovedI",
				-- 		"ModeChanged",
				-- 	},
				-- },
			},
			sections = {
				lualine_a = { "mode" },
				-- lualine_b = { "branch","diff", "diagnostics" },
				lualine_b = { { "branch", show_filename_only = false } },
				-- lualine_c = { "filename" },
				lualine_c = {
					{
						"buffers",
						buffers_color = {
							-- sets the active buffer name to something that stands out (purple for edge theme)
							active = function()
								local function get_hl_hex(group, attr)
									local hl = vim.api.nvim_get_hl(0, { name = group })
									if hl[attr] then
										return string.format("#%06x", hl[attr])
									end
									return nil
								end

								local accent = get_hl_hex("Statement", "fg")
								return { fg = accent }
							end,
						},
					},
				},
				-- lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_x = { "filetype" },
				-- lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			-- inactive_sections = {
			-- 	lualine_a = {},
			-- 	lualine_b = {},
			-- 	lualine_c = { "filename" },
			-- 	lualine_x = { "location" },
			-- 	lualine_y = {},
			-- 	lualine_z = {},
			-- },
			-- tabline = {},
			-- winbar = {},
			-- inactive_winbar = {},
			-- extensions = {},
		})
	end,
}
