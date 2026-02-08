local calyx_path = "/home/thebu/newhome/calyx"
local calyx_futil_path = calyx_path .. "/tools/vim/futil"

return {

	-- SudaWrite
	{
		"lambdalisue/vim-suda",
	},
	-- sshfs plugin, heavensent for unstable connections
	--{
	--  "uhs-robert/sshfs.nvim",
	--  opts = {
	--    -- Refer to the configuration section below
	--    -- or leave empty for defaults
	--  },
	--},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},

	-- Configure LazyVim to load colorscheme
	--{
	--  -- https://github.com/ellisonleao/gruvbox.nvim
	--  "ellisonleao/gruvbox.nvim",
	--  opts = {
	--    transparent_mode = false,
	--    dim_inactive = true,
	--  },
	--},
	-- {
	--   "LazyVim/LazyVim",
	--   opts = {
	--     --colorscheme = "gruvbox",
	--     colorscheme = "catppuccin",
	--   },
	-- },

	---- Calyx LSP (from source)
	--vim.fn.isdirectory(calyx_futil_path) == 1 -- check if lsp is on system
	--    and {
	--      dir = calyx_futil_path,
	--      ft = { "futil", "calyx" }, -- ft is filetypes
	--      config = function()
	--        require("futil").setup({
	--          calyxLsp = {
	--            libraryPaths = { calyx_path }, -- lsp path
	--          },
	--        })
	--      end,
	--    }
	--  or nil,

	--
	-- WARN: The following breaks clangd.
	--
	--
	-- Original Slang + double commented out hyprlang
	--
	-- {
	--   "neovim/nvim-lspconfig",
	--   event = "LazyFile",
	--   --   dependencies = {
	--   --     "mason.nvim",
	--   --     { "williamboman/mason-lspconfig.nvim", config = function() end },
	--   --   },
	--   opts = function()
	--     return {
	--       setup = {
	--         slang = function()
	--           vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	--             pattern = { "*.v", "*.sv" },
	--             callback = function()
	--               vim.lsp.start({
	--                 name = "slang_for_sv_and_v",
	--                 cmd = { "veridian" },
	--                 root_dir = vim.fn.getcwd(),
	--               })
	--             end,
	--           })
	--           return true
	--         end,
	--         --         hyprlang = function()
	--         --           require("lspconfig").hyprlang.setup({
	--         --             cmd = { "hyprls" }, -- Path to hyprls executable
	--         --             root_dir = vim.fn.getcwd(),
	--         --           })
	--         --           return true
	--         --         end,
	--       },
	--       --       diagnostics = {
	--       --         virtual_text = { spacing = 4, prefix = "●" },
	--       --       },
	--     }
	--   end,
	--   config = function(_, opts)
	--     LazyVim.lsp.setup()
	--     -- Set up Slang LSP
	--     if opts.setup.slang then
	--       opts.setup.slang()
	--     end
	--     --     if opts.setup.hyprlang then
	--     --       opts.setup.hyprlang()
	--     --     end
	--     --     vim.diagnostic.config(opts.diagnostics)
	--   end,
	-- },

	--  -- original CLANG
	--  {
	--    "neovim/nvim-lspconfig",
	--    opts = {
	--      servers = {
	--        clangd = {
	--          cmd = { "clangd" },
	--          filetypes = { "c", "cpp", "objc", "objcpp" },
	--          root_dir = require("lspconfig").util.root_pattern(
	--            ".git",
	--            "compile_commands.json",
	--            "compile_flags.txt",
	--            ".clangd"
	--          ),
	--          single_file_support = true,
	--          capabilities = require("cmp_nvim_lsp").default_capabilities(),
	--        },
	--      },
	--    },
	--  },

	-- ChatGPT merged my slang/veridian code with some Clangd code i found.
	-- It seems to work aight, but i switched to verible and svls with mason because the LSP never worked right
	-- {
	--   "neovim/nvim-lspconfig",
	--   event = "LazyFile", -- You may still want to lazy-load based on file event
	--   opts = function()
	--     return {
	--       setup = {
	--         slang = function()
	--           vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	--             pattern = { "*.v", "*.sv" },
	--             callback = function()
	--               vim.lsp.start({
	--                 name = "slang_for_sv_and_v",
	--                 cmd = { "veridian" },
	--                 root_dir = vim.fn.getcwd(),
	--               })
	--             end,
	--           })
	--           return true
	--         end,
	--       },
	--       servers = {
	--         clangd = {
	--           cmd = { "clangd" },
	--           filetypes = { "c", "cpp", "objc", "objcpp" },
	--           root_dir = require("lspconfig").util.root_pattern(
	--             ".git",
	--             "compile_commands.json",
	--             "compile_flags.txt",
	--             ".clangd"
	--           ),
	--           single_file_support = true,
	--           capabilities = require("cmp_nvim_lsp").default_capabilities(),
	--         },
	--       },
	--     }
	--   end,
	--   config = function(_, opts)
	--     LazyVim.lsp.setup()

	--     -- Set up Slang LSP if needed
	--     if opts.setup.slang then
	--       opts.setup.slang()
	--     end

	--     -- Configure LSP servers
	--     for server, config in pairs(opts.servers) do
	--       require("lspconfig")[server].setup(config)
	--     end
	--   end,
	-- },
}
