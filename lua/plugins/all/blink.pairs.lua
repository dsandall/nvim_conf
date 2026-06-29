return {
	"saghen/blink.pairs",
	version = "*", -- (recommended) only required with prebuilt binaries

	dependencies = "saghen/blink.lib",

	build = function()
		require("blink.pairs").download():pwait(60000)
	end,

	-- download prebuilt binaries from github releases
	-- dependencies = "saghen/blink.download",
	-- OR build from source, requires nightly:
	-- https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	--- @module 'blink.pairs'
	--- @type blink.pairs.Config
	opts = {
		mappings = { enabled = false },
		highlights = {
			enabled = true,
			-- requires require('vim._extui').enable({}), otherwise has no effect
			cmdline = true,
			groups = {
				"BlinkPairsOrange",
				"BlinkPairsPurple",
				"BlinkPairsBlue",
			},
			unmatched_group = "BlinkPairsUnmatched",

			-- highlights matching pairs under the cursor
			matchparen = {
				enabled = true,
				-- known issue where typing won't update matchparen highlight, disabled by default
				cmdline = false,
				-- also include pairs not on top of the cursor, but surrounding the cursor
				include_surrounding = false,
				group = "BlinkPairsMatchParen",
				priority = 250,
			},
		},
		debug = false,
	},
}
