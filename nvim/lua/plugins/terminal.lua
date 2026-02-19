return {
	{
		"akinsho/toggleterm.nvim",
		opts = {
			-- NOTE: <C-f> conflicts with nvim-cmp scroll_docs mapping
			-- This works because toggleterm uses normal mode and cmp uses insert mode
			-- If issues arise, consider changing to <C-\> or <C-t>
			open_mapping = "<C-f>",
			hide_numbers = true,
			auto_scroll = true,
		},
	},
}
