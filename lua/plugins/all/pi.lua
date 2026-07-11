-- pi.nvim - A Neovim plugin for interacting with pi (the minimal CLI agent)
-- Local fork at: ~/dev/pi.nvim - runs pi agent TUI in embedded terminal
--
-- Key concept: A single persistent pi session maintains full conversation history.
-- Neovim embeds the standard pi TUI in a window. The :PiAsk commands simply
-- forward context (buffer/selection) into the running session.

-- Requirements:
--   npm install -g @mariozechner/pi-coding-agent

return {
	-- Use local development copy
	dir = vim.fn.expand("~/dev/pi.nvim"),

	config = function()
		require("pi").setup({
			-- Provider and model (optional - uses pi's default if not set)
			-- provider = "openrouter",
			-- model = "openrouter/free",

			-- Context limits when sending buffer content
			-- max_context_lines = 300,
			-- max_context_bytes = 24000,
			-- selection_context_lines = 40,

			-- Window configuration
			-- window_style = "float",      -- "float" or "split"
			-- split_direction = "right",   -- for split style: "left", "right", "above", "below"
			-- split_size = 60,             -- width/height for splits
		})

		-- ============================================
		-- Keymaps
		-- ============================================

		-- Show/toggle the pi agent window (embedded pi TUI)
		vim.keymap.set("n", "<leader>ai", ":PiToggle<CR>", { desc = "Toggle pi agent window" })

		-- Ask with current buffer as context (prompts for question, sends to pi)
		vim.keymap.set("n", "<leader>aq", ":PiAsk<CR>", { desc = "Ask pi with buffer context" })

		-- Ask with visual selection as context
		vim.keymap.set("v", "<leader>aq", ":PiAskSelection<CR>", { desc = "Ask pi with selection context" })

		-- Quick paste: send entire buffer content to pi (no prompt)
		vim.keymap.set("n", "<leader>ap", ":PiPaste<CR>", { desc = "Paste buffer into pi chat" })

		-- Quick paste selection
		vim.keymap.set("v", "<leader>ap", ":PiPasteSelection<CR>", { desc = "Paste selection into pi chat" })

		-- Stop the pi session (kills the process)
		-- vim.keymap.set("n", "<leader>as", ":PiStop<CR>", { desc = "Stop pi session" })

		-- ============================================
		-- Commands
		-- ============================================

		-- :Pi               - Show pi agent window (starts session if needed)
		-- :PiToggle         - Toggle window visibility
		-- :PiStop           - Kill the pi session
		-- :PiAsk            - Prompt for question, send with buffer context
		-- :PiAskSelection   - Same but with visual selection context
		-- :PiPaste          - Send entire buffer content to pi
		-- :PiPasteSelection - Send selection to pi

		-- ============================================
		-- Usage Flow
		-- ============================================
		--
		-- 1. Open pi window with <leader>ai
		--    - This is the standard pi TUI running inside nvim
		--    - Full conversation history is maintained automatically
		--
		-- 2. Work in your code buffer
		--
		-- 3. When you need AI help with current file:
		--    - <leader>aq to ask a question with full buffer context
		--    - Or <leader>ap to just paste the buffer content
		--
		-- 4. Switch back to pi window to see response (or it may auto-show)
		--    - Continue conversation naturally in the TUI
		--    - All history preserved
		--
		-- 5. Close pi window with 'q' or <C-q> (session keeps running)
		--    - Reopen anytime with <leader>ai
	end,
}
