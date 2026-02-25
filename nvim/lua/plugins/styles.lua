return {
	{
		"morhetz/gruvbox",
		lazy = false,
		priority = 1000,
	},
	{ "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000, opts = { auto_integrations = true } },
	{ "nvim-tree/nvim-web-devicons", opts = {} },
	{
		"nvim-lualine/lualine.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim", "morhetz/gruvbox" },
	},
}
