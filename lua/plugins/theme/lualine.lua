return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local function get_hl_hex(group, attr)
			local hl = vim.api.nvim_get_hl(0, { name = group })
			if hl[attr] then
				return string.format("#%06x", hl[attr])
			end
			return nil
		end

		require("lualine").setup({
			sections = {},
			inactive_sections = {},
			tabline = {
				lualine_a = {
					"location",

					{
						--NOTE: https://github.com/nvim-lualine/lualine.nvim#buffers-component-options
						"buffers",
						show_filename_only = true,
						hide_filename_extension = false,
						show_modified_status = true,

						filter = function(bufnr)
							local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
							local name = vim.api.nvim_buf_get_name(bufnr)

							-- hide special buffers
							if buftype ~= "" then
								return false
							end

							-- hide unnamed buffers
							if name == "" then
								return false
							end

							return true
						end,
						buffers_color = {
							active = function()
								local accent = get_hl_hex("Statement", "fg")
								local fg = get_hl_hex("Normal", "bg")
								return { bg = accent, fg = fg }
							end,
						},
					},
				},

				lualine_y = { "diagnostics", "diff", "branch" },
			},
		})

		-- Disable the statusline (lualine only manages the tabline)
		vim.o.laststatus = 0
	end,
}
