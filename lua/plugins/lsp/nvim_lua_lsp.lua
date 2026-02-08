--------------------------------------------------
-- Copied from kickstart.nvim, and slightly edited
--------------------------------------------------
local servers = {
	-- clangd = {},
	lua_ls = {},
}
--[[ for name, server in pairs(servers) do
	server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
	vim.lsp.config(name, server)
	vim.lsp.enable(name)
end ]]

local lua_ls_init = function(client)
	-- first, check if this is a real lua project file & return early
	if client.workspace_folders then
		local path = client.workspace_folders[1].name
		if
			path ~= vim.fn.stdpath("config")
			and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
		then
			return
		end
	end

	-- if this is not a regular lua file, import full neovim lua API files
	client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
		runtime = {
			version = "LuaJIT",
			path = { "lua/?.lua", "lua/?/init.lua" },
		},
		workspace = {
			checkThirdParty = false,
			---[[
			-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
			--  See https://github.com/neovim/nvim-lspconfig/issues/3189
			--
			--  Replaced this:
			library = vim.api.nvim_get_runtime_file("", true),
			--
			-- with this:
			-- ]]
			library = vim.tbl_filter(function(d)
				return not d:match(vim.fn.stdpath("config") .. "/?a?f?t?e?r?")
			end, vim.api.nvim_get_runtime_file("", true)),
		},
	})
end

-- Special Lua Config, as recommended by neovim help docs
vim.lsp.config["lua_ls"] = {
	settings = {
		Lua = {},
	},
	on_init = lua_ls_init,
}

vim.lsp.enable("lua_ls")

return {}
