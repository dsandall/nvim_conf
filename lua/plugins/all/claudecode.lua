-- Persistent, per-project Claude Code <-> Neovim integration (official IDE protocol).
--
-- Model: each PROJECT (git root) gets its own persistent Claude, living in its own
-- tmux window started IN that root. Opening Neovim in a project reattaches its Claude
-- automatically; <leader>ci spawns one on demand if none is running. Because the tmux
-- window, the socket pointer, and the workspace Neovim advertises are all keyed to the
-- same git root, Claude Code's "cwd must match the IDE workspace" check always passes.
--
-- Companion: mcp/nvim_nav.py (registered via `claude mcp add nvim-nav`) gives Claude an
-- `open_in_nvim` tool so it can navigate your live buffers to a file/region.

local function in_tmux()
	return vim.env.TMUX ~= nil
end

-- Deterministic 32-bit hash (djb2) -- MUST match hash_str() in mcp/nvim_nav.py.
local function hash_str(s)
	local h = 5381
	for i = 1, #s do
		h = (h * 33 + s:byte(i)) % 4294967296
	end
	return string.format("%08x", h)
end

-- The project root that everything keys off: the git toplevel of the cwd, else the cwd.
local function project_root()
	local out = vim.fn.systemlist({ "git", "-C", vim.fn.getcwd(), "rev-parse", "--show-toplevel" })
	if vim.v.shell_error == 0 and out[1] and out[1] ~= "" then
		return out[1]
	end
	return vim.fn.getcwd()
end

-- tmux window name for a root: readable basename + hash so distinct paths never collide.
local function win_name(root)
	local base = vim.fn.fnamemodify(root, ":t"):gsub("[^%w._-]", "-")
	return "cc-" .. base .. "-" .. hash_str(root)
end

local function nav_dir()
	return vim.fn.stdpath("cache") .. "/claude-nav"
end

-- Publish this Neovim's RPC socket for the nvim-nav MCP tool, keyed by project root.
local function write_pointer()
	local sock = vim.v.servername
	if not sock or sock == "" then
		return
	end
	vim.fn.mkdir(nav_dir(), "p")
	vim.fn.writefile({ sock }, nav_dir() .. "/" .. hash_str(project_root()))
end

local function tmux_window_exists(name)
	for _, n in ipairs(vim.fn.systemlist({ "tmux", "list-windows", "-a", "-F", "#{window_name}" })) do
		if n == name then
			return true
		end
	end
	return false
end

-- Reattach an already-running project Claude to THIS Neovim (no spawning).
local function claude_reattach()
	if not in_tmux() then
		return
	end
	local name = win_name(project_root())
	if tmux_window_exists(name) then
		vim.fn.system({ "tmux", "send-keys", "-t", name, "/ide", "Enter" })
	end
end

-- <leader>ci: ensure a Claude is running for this project, then connect it.
local function claude_connect()
	if not in_tmux() then
		vim.notify("claudecode: start Neovim inside tmux to use per-project Claude", vim.log.levels.WARN)
		return
	end
	local root = project_root()
	local name = win_name(root)
	if tmux_window_exists(name) then
		vim.fn.system({ "tmux", "send-keys", "-t", name, "/ide", "Enter" })
		vim.notify("claudecode: reconnected Claude for " .. vim.fn.fnamemodify(root, ":t"))
	else
		-- Spawn Claude in the project root (-d: don't steal focus from Neovim),
		-- then connect once it has booted.
		vim.fn.system({ "tmux", "new-window", "-d", "-n", name, "-c", root, "claude" })
		vim.notify("claudecode: starting Claude for " .. vim.fn.fnamemodify(root, ":t") .. " …")
		vim.defer_fn(function()
			vim.fn.system({ "tmux", "send-keys", "-t", name, "/ide", "Enter" })
		end, 3000)
	end
end

-- Jump tmux focus to this project's Claude window.
local function claude_focus()
	if not in_tmux() then
		return
	end
	vim.fn.system({ "tmux", "select-window", "-t", win_name(project_root()) })
end

return {
	"coder/claudecode.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	-- Load at startup so the server is listening and can auto-reattach on launch.
	event = "VeryLazy",
	config = function()
		require("claudecode").setup({
			auto_start = true,
			-- A small range (not a single pinned port) so multiple projects can be
			-- open at once; each Neovim gets its own lock file and Claude matches the
			-- right one by workspace.
			port_range = { min = 55120, max = 55140 },
			terminal = {
				provider = "none", -- Neovim runs the server + tools; Claude lives in tmux
				git_repo_cwd = true, -- advertise the git root as the workspace (matches spawn dir)
			},
			diff_opts = { layout = "vertical" },
		})

		-- Keep the nav socket pointer current for this project.
		write_pointer()
		vim.api.nvim_create_autocmd("DirChanged", { callback = write_pointer })
		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = function()
				vim.fn.delete(nav_dir() .. "/" .. hash_str(project_root()))
			end,
		})

		-- On launch, reattach this project's Claude if one is already running.
		if in_tmux() then
			vim.defer_fn(claude_reattach, 800)
		end

		-- Keymaps under <leader>c (pi owns <leader>a).
		local map = vim.keymap.set
		map({ "v", "n" }, "<leader>cs", "<cmd>ClaudeCodeSend<cr>", { desc = "Claude: send selection / tree file" })
		map("n", "<leader>ca", ":ClaudeCodeAdd %<cr>", { desc = "Claude: add current file" })
		map("n", "<leader>ci", claude_connect, { desc = "Claude: start/connect project session" })
		map("n", "<leader>cf", claude_focus, { desc = "Claude: focus tmux window" })
		map("n", "<leader>cy", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Claude: accept diff" })
		map("n", "<leader>cn", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Claude: reject diff" })
		map("n", "<leader>cS", "<cmd>ClaudeCodeStatus<cr>", { desc = "Claude: server status" })
	end,
}
