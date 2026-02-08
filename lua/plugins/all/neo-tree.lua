-- open neo-tree when opening a directory
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local arg = vim.fn.argv(0)
		if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
			vim.cmd("cd " .. vim.fn.argv(0))
			vim.cmd("Neotree show")
		end
	end,
})

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	lazy = false, -- necessary for my VimEnter autocommand to fire properly
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"echasnovski/mini.icons",
		"nvim-tree/nvim-web-devicons",
	},
	cmd = { "Neotree" },
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
	},
	opts = {
		icon_provider = "mini.icons",
		filesystem = {
			follow_current_file = {
				enabled = true,
				leave_dirs_open = true,
			},
			use_libuv_file_watcher = true,
		},
	},
}
