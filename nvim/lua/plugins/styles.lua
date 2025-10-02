return {
	{
		"morhetz/gruvbox",
		lazy = false,
		priority = 1000,
	},
	{ "nvim-tree/nvim-web-devicons", opts = {} },
	{
		"nvim-lualine/lualine.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons", "morhetz/gruvbox" },
	},
}
