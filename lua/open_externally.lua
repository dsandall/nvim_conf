-- Open files that Neovim can't meaningfully render/edit in an external program,
-- instead of dumping binary content into a buffer.
--
-- Tiers:
--   1. browser_patterns  -> Firefox (images, svg, pdf: it renders these natively)
--   2. system_patterns   -> system default app via xdg-open (video, audio, office docs)
--   3. <leader>ie keymap -> open the CURRENT file in Firefox on demand
--      (for html/markdown/etc. that you still want to *edit* in nvim)
local M = {}

local BROWSER = "firefox"

-- handed straight to the browser
local browser_patterns = {
	"*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.bmp", "*.svg", "*.pdf",
}

-- handed to the OS default handler
local system_patterns = {
	"*.mp4", "*.mkv", "*.webm", "*.mov", "*.avi",
	"*.mp3", "*.flac", "*.wav", "*.ogg", "*.m4a",
	"*.odt", "*.ods", "*.odp", "*.docx", "*.xlsx", "*.pptx",
}

-- launch `cmd` (list form) detached so it survives after nvim, and don't block
local function spawn(cmd)
	vim.fn.jobstart(cmd, { detach = true })
end

local function open_in_browser(file)
	spawn({ BROWSER, "file://" .. vim.fn.fnamemodify(file, ":p") })
end

-- BufReadCmd fully takes over reading the file, so nvim never renders binary.
local function hijack(group, patterns, launch)
	vim.api.nvim_create_autocmd("BufReadCmd", {
		group = group,
		pattern = patterns,
		callback = function(ev)
			launch(ev.file)
			vim.schedule(function()
				vim.cmd("bwipeout! " .. ev.buf) -- drop the empty buffer nvim made
			end)
			vim.notify("Opened " .. vim.fn.fnamemodify(ev.file, ":t") .. " externally")
		end,
	})
end

function M.setup()
	local group = vim.api.nvim_create_augroup("OpenExternally", { clear = true })

	hijack(group, browser_patterns, open_in_browser)
	hijack(group, system_patterns, function(file)
		spawn({ "xdg-open", vim.fn.fnamemodify(file, ":p") })
	end)

	-- on-demand: open whatever file the current buffer holds in Firefox
	-- (great for html/markdown source you edit in nvim but want to preview)
	vim.keymap.set("n", "<leader>ie", function()
		local file = vim.api.nvim_buf_get_name(0)
		if file == "" then
			vim.notify("No file in this buffer", vim.log.levels.WARN)
			return
		end
		open_in_browser(file)
	end, { desc = "Open current file in Firefox" })
end

return M
