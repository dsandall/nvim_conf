-- allows nvim to change its directory when you open a dir on startup
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
			vim.cmd("cd " .. vim.fn.argv(0))
		end
	end,
})

return {}
