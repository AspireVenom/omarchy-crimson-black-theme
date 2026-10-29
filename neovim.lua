-- Crimson Black: aether.nvim (Omarchy org, v3) fed this theme's palette directly (colors.toml).
return {
	{
		"omacom-io/aether.nvim",
		branch = "v3",
		name = "aether",
		lazy = false,
		priority = 1000,
		opts = {
			colors = {
				bg = "#000000",
				dark_bg = "#000000",
				darker_bg = "#000000",
				lighter_bg = "#1a1a1a",

				fg = "#e6e3df",
				dark_fg = "#a8a5a1",
				light_fg = "#efedea",
				bright_fg = "#ffffff",
				muted = "#7c7c7c",

				red = "#ef2a42",
				yellow = "#d9c9a3",
				orange = "#e8808b",
				green = "#a9b8a3",
				cyan = "#c6c6c6",
				blue = "#a9aeb9",
				purple = "#e8808b",
				brown = "#8a6a6e",

				bright_red = "#f14157",
				bright_yellow = "#ece0c2",
				bright_green = "#c5d1c0",
				bright_cyan = "#dedede",
				bright_blue = "#c9ccd4",
				bright_purple = "#f4a9b0",

				accent = "#ef2a42",
				cursor = "#ef2a42",
				foreground = "#e6e3df",
				background = "#000000",
				selection = "#2a080d",
				selection_foreground = "#ffffff",
				selection_background = "#5c0d16",
			},
		},
		config = function(_, opts)
			require("aether").setup(opts)
			vim.cmd.colorscheme("aether")
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "aether",
		},
	},
}
