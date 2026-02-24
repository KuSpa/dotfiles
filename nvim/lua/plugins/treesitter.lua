return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"javascript",
					"typescript",
					"rust",
					"markdown",
					"markdown_inline",
					"json",
					"yaml",
					"html",
					"css",
					"scss",
					"bash",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						node_incremental = "v",
						node_decremental = "V",
					},
				},
				highlight = {
					enable = true,
					disable = function(_, buf)
						local max_filesize = 100 * 1024
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
				auto_install = true,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			local ts = require("nvim-treesitter-textobjects")
			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")
			local swap = require("nvim-treesitter-textobjects.swap")

			ts.setup({ select = { lookahead = true }, move = { set_jumps = true } })

			-- Select keymaps
			for lhs, query in pairs({
				af = "@function.outer",
				["if"] = "@function.inner",
				ac = "@class.outer",
				ic = "@class.inner",
				aa = "@parameter.outer",
				ia = "@parameter.inner",
			}) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					select.select_textobject(query, "textobjects")
				end)
			end

			-- Move keymaps
			for lhs, fn in pairs({
				["]f"] = { move.goto_next_start, "@function.outer" },
				["]F"] = { move.goto_next_end, "@function.outer" },
				["[f"] = { move.goto_previous_start, "@function.outer" },
				["[F"] = { move.goto_previous_end, "@function.outer" },
				["]c"] = { move.goto_next_start, "@class.outer" },
				["]C"] = { move.goto_next_end, "@class.outer" },
				["[c"] = { move.goto_previous_start, "@class.outer" },
				["[C"] = { move.goto_previous_end, "@class.outer" },
				["]a"] = { move.goto_next_start, "@parameter.inner" },
				["[a"] = { move.goto_previous_start, "@parameter.inner" },
			}) do
				vim.keymap.set({ "n", "x", "o" }, lhs, function()
					fn[1](fn[2], "textobjects")
				end)
			end

			-- Swap keymaps
			--vim.keymap.set("n", "<leader>sa", function()
			--	swap.swap_next("@parameter.inner")
			--end, { desc = "Swap argument next" })
			--vim.keymap.set("n", "<leader>sA", function()
			--	swap.swap_previous("@parameter.inner")
			--end, { desc = "Swap argument previous" })
		end,
	},
}
