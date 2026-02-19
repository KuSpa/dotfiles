-- Git root helpers for Telescope
local function is_git_repo()
	vim.fn.system("git rev-parse --is-inside-work-tree")
	return vim.v.shell_error == 0
end

local function get_git_root()
	local dot_git_path = vim.fn.finddir(".git", ".;")
	return vim.fn.fnamemodify(dot_git_path, ":h")
end

local function get_git_opts()
	if is_git_repo() then
		return { cwd = get_git_root() }
	end
	return {}
end

return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files(get_git_opts())
				end,
				desc = "Find files (git root)",
			},
			{
				"<leader>fg",
				function()
					require("telescope.builtin").live_grep(get_git_opts())
				end,
				desc = "Live grep (git root)",
			},
			{
				"<leader>fb",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>fh",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "Help tags",
			},
			{
				"<leader>fd",
				function()
					require("telescope.builtin").diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				"<leader>fn",
				":Telescope file_browser path=%:p:h select_buffer=true<CR>",
				desc = "File browser",
			},
		},
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					path_display = { shorten = { len = 1, exclude = { -1 } } },
					dynamic_preview_title = true,
					preview = { treesitter = false },
				},
				pickers = {
					buffers = {
						mappings = {
							i = {
								["<c-d>"] = actions.delete_buffer + actions.move_to_top,
							},
						},
					},
				},
				extensions = {
					file_browser = {
						-- disables netrw and use telescope-file-browser in its place
						hijack_netrw = true,
						hidden = true,
						mappings = {
							["i"] = {
								["…"] = actions.close,
							},
							["n"] = {
								["…"] = actions.close,
							},
						},
					},
				},
			})
			-- Load extension AFTER telescope.setup()
			require("telescope").load_extension("file_browser")
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
}
