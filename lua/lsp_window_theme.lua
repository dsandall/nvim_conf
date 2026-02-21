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
		Normal                                 = { bg = "#f4f1e8", fg = "#2a2a2a" },
		Comment                                = { fg = "#9a8f82", italic = true },
		LineNr                                 = { fg = "#c2bfae" },
		CursorLine                             = { bg = "#ece8dc" },
		Visual                                 = { bg = "#d8d0c0" },

		-- headings: warm earth/slate tones, heavier at the top
		["@markup.heading.1.markdown"]         = { fg = "#3a5068", bold = true },
		["@markup.heading.2.markdown"]         = { fg = "#4a6058", bold = true },
		["@markup.heading.3.markdown"]         = { fg = "#7a5840", bold = true },
		["@markup.heading.4.markdown"]         = { fg = "#5a5070" },
		["@markup.heading.5.markdown"]         = { fg = "#687060" },
		["@markup.heading.6.markdown"]         = { fg = "#807868" },

		-- inline formatting
		["@markup.bold.markdown"]              = { fg = "#1a1a1a", bold = true },
		["@markup.italic.markdown"]            = { fg = "#4a3e34", italic = true },

		-- inline code: slightly cooler/darker bg to distinguish it
		["@markup.raw.block.markdown"]         = { bg = "#ded9cc", fg = "#5c3a1e" },

		-- links
		["@markup.link.label.markdown_inline"] = { fg = "#5b7fa6", underline = true },
		["@markup.link.url.markdown_inline"]   = { fg = "#8a9a7a", italic = true },

		-- lists
		["@markup.list.markdown"]              = { fg = "#7a6a58" },
		["@markup.list.checked.markdown"]      = { fg = "#6a8a6a" },
		["@markup.list.unchecked.markdown"]    = { fg = "#9a8a78" },

		-- blockquote
		["@markup.quote.markdown"]             = { fg = "#7d7068", italic = true, bg = "#ede8da" },

		-- the ##, **, _, etc. punctuation — muted so content stands out
		["@punctuation.special.markdown"]      = { fg = "#b8b0a0" },
		["@punctuation.delimiter.markdown"]    = { fg = "#b8b0a0" },
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
