return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		on_attach = function(bufnr)
			local gs = require("gitsigns")
			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end

			-- Navigate hunks
			map("n", "]h", function()
				gs.nav_hunk("next")
			end, "Next hunk")
			map("n", "[h", function()
				gs.nav_hunk("prev")
			end, "Prev hunk")

			-- Stage / reset BY HUNK (git add -p equivalent). stage_hunk toggles:
			-- run it on a staged hunk to unstage.
			map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
			map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
			-- Visual selection = stage/reset just those lines (partial hunk).
			map("v", "<leader>hs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Stage selected lines")
			map("v", "<leader>hr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Reset selected lines")

			map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
			map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
			map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
			map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
			map("n", "<leader>hb", function()
				gs.blame_line({ full = true })
			end, "Blame line")
		end,
	},
}
