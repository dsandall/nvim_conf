-- Automatically searches for folders within lua/plugins.
-- the same thing as doing this:
--[[ return {
	{ import = "plugins.lsp" },
	{ import = "plugins.all" },
	{ import = "plugins.*" },
} ]]

local imports = {}

local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"

for _, entry in ipairs(vim.fn.readdir(plugin_dir)) do
	local full = plugin_dir .. "/" .. entry

	if vim.fn.isdirectory(full) == 1 then
		table.insert(imports, { import = "plugins." .. entry })
	end
end

return imports
