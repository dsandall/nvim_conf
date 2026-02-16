local M = {}

local api = vim.api
local ns_cache = {}

-- ---------- palettes by filetype ----------
local palettes = {
	c = {
		Normal = { bg = "#0f1419" },
		Comment = { fg = "#5c6773", italic = true },
	},

	cpp = {
		Normal = { bg = "#0f1419" },
		Comment = { fg = "#5c6773", italic = true },
	},

	rust = {
		Normal = { bg = "#1b1b1b" },
		Comment = { fg = "#7a7a7a", italic = true },
	},

	systemverilog = {
		Normal = { bg = "#1a1026" },
		Comment = { fg = "#8a6fa5", italic = true },
	},

	verilog = {
		Normal = { bg = "#1a1026" },
		Comment = { fg = "#8a6fa5", italic = true },
	},

	markdown = {
		Normal = { bg = "#f4f1e8", fg = "#2a2a2a" },
		Comment = { fg = "#6b6b6b", italic = true },
		LineNr = { fg = "#c2bfae" },
	},

	fish = {
		Normal = { bg = "#0e1a1a" },
		Comment = { fg = "#5f8787", italic = true },
	},

	python = {
		Normal = { bg = "#111a11" },
		Comment = { fg = "#6a8f6a", italic = true },
	},
}

-- ---------- helpers ----------
local function get_ns(filetype)
	if ns_cache[filetype] then
		return ns_cache[filetype]
	end

	local palette = palettes[filetype]
	if not palette then
		return nil
	end

	local ns = api.nvim_create_namespace("win_theme_" .. filetype)
	ns_cache[filetype] = ns

	for group, spec in pairs(palette) do
		api.nvim_set_hl(ns, group, spec)
	end

	return ns
end

local function apply_theme_for_buffer(buf)
	local ft = vim.bo[buf].filetype
	local ns = get_ns(ft)
	api.nvim_win_set_hl_ns(0, ns or 0)
end

-- ---------- autocmd ----------
function M.setup()
	api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "FileType" }, {
		callback = function(args)
			apply_theme_for_buffer(args.buf)
		end,
	})
end

return M

