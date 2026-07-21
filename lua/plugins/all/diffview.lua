return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
	keys = {
		{ "<leader>gd", "<Cmd>DiffviewOpen<CR>", desc = "Diffview: working tree" },
		{ "<leader>gD", "<Cmd>DiffviewOpen HEAD<CR>", desc = "Diffview: HEAD" },
		{ "<leader>gh", "<Cmd>DiffviewFileHistory %<CR>", desc = "Diffview: current file history" },
		{ "<leader>gH", "<Cmd>DiffviewFileHistory<CR>", desc = "Diffview: repository history" },
		{ "<leader>gq", "<Cmd>DiffviewClose<CR>", desc = "Diffview: close" },
	},
	opts = {
		view = {
			default = { layout = "diff2_horizontal" },
			merge_tool = { layout = "diff3_horizontal" },
			file_history = { layout = "diff2_horizontal" },
		},
		file_panel = {
			listing_style = "tree",
			win_config = {
				position = "left",
				width = 35,
			},
		},
	},
}
