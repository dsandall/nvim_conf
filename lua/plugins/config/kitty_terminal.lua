-- opens a Kitty terminal when <C-/>
-- requires Kitty configuration
--
open_kitty_term = function(command)
	local socket = vim.env.KITTY_LISTEN_ON
	if not socket then
		vim.notify("KITTY_LISTEN_ON not set", vim.log.levels.ERROR)
		return
	end

	local args = { "kitty", "@", "--to", socket, "launch", "--type=os-window", "--cwd=" .. vim.fn.getcwd() }
	if command then
		for arg in command:gmatch("%S+") do
			table.insert(args, arg)
		end
	end
	vim.fn.system(args)
end

vim.keymap.set("n", "<C-/>", open_kitty_term, { desc = "Open kitty terminal in cwd" })

return {}
