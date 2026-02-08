-- opens a Kitty terminal when <C-/>
-- requires Kitty configuration

vim.keymap.set("n", "<C-/>", function()
	local socket = vim.env.KITTY_LISTEN_ON
	if socket then
		vim.fn.system({ "kitty", "@", "--to", socket, "launch", "--type=os-window", "--cwd=" .. vim.fn.getcwd() })
	else
		vim.notify("KITTY_LISTEN_ON not set", vim.log.levels.ERROR)
	end
end, { desc = "Open kitty terminal in cwd" })

return {}
