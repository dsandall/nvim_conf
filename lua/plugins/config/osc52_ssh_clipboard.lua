local function is_ssh()
	-- true if operating over SSH (remote connection)
	return vim.env.SSH_TTY ~= nil or vim.env.SSH_CONNECTION ~= nil
end

-- Sync clipboard between OS and Neovim.
if is_ssh() then
	-- osc52 is a non-standard, but widely implemented terminal control
	-- sequence which allows applications to write data into the system clipboard
	-- by sending special escape-codes to the terminal emulator.
	--
	-- Use this to enable the ability to provide system-clipboard
	-- interaction with neovim over remote SSH connections
	local osc52 = require("vim.ui.clipboard.osc52")

	-- Register OSC52 as the real clipboard provider so that ANY write to the
	-- + / * registers (yanks via unnamedplus, but also plugin setreg() calls,
	-- e.g. avante copying its OAuth URL) reaches the local clipboard.
	-- Paste falls back to the unnamed register: querying the terminal's
	-- clipboard (osc52.paste) hangs on terminals that refuse to answer;
	-- use the terminal's own paste (ctrl+shift+v) for local->remote instead.
	local function paste_fallback()
		return vim.split(vim.fn.getreg('"'), "\n")
	end
	vim.g.clipboard = {
		name = "OSC 52 (copy only)",
		copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
		paste = { ["+"] = paste_fallback, ["*"] = paste_fallback },
	}
end

vim.opt.clipboard = "unnamedplus"

return {}
