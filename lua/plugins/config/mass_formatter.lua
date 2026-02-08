vim.api.nvim_create_user_command("FormatAllPython", function()
	local conform = require("conform")
	for _, file in ipairs(vim.fn.glob("**/*.py", false, true)) do
		local bufnr = vim.fn.bufadd(file)
		vim.fn.bufload(bufnr)
		conform.format({ bufnr = bufnr, async = false })
		vim.api.nvim_buf_call(bufnr, function()
			vim.cmd("write")
		end)
		vim.api.nvim_buf_delete(bufnr, {})
	end
	print("Formatted all Python files")
end, {})

return {}
