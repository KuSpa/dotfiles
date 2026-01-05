return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader>f",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		-- This will provide type hinting with LuaLS
		---@module "conform"
		---@type conform.setupOpts
		opts = {
			-- Define your formatters
			formatters_by_ft = {
				lua = { "stylua" },
				css = { "prettierd", "prettier", stop_after_first = true },
				scss = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				javascript = { "prettierd", "prettier", stop_after_first = true },
			},
			-- Set default options
			default_format_opts = {
				lsp_format = "fallback",
			},
			-- Set up format-on-save
			format_on_save = { timeout_ms = 500 },
		},
	},
	{
		"hrsh7th/nvim-cmp",
		version = false, -- last release is way too old
		--event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		opts = function()
			-- brauche ich das? setzt highlights lol
			vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
			local opts = { noremap = true, silent = true }
			--vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>",	opts)
			vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
			vim.api.nvim_set_keymap("n", "<leader>ge", "<cmd>lua vim.lsp.buf.code_action() <CR>", opts)
			local cmp = require("cmp")
			return {
				mapping = cmp.mapping.preset.insert({
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					--["<C-j>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-CR>"] = function(fallback)
						cmp.abort()
						fallback()
					end,
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					-- for now i am happy with what i got. I don't know why it is weird on .md files
					-- { name = "path" },
					--        { name = "buffer" },
				}),
			}
		end,
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		opts = {
			preview = { icon_provider = "devicons" },
		},
		-- Completion for `blink.cmp`
		-- dependencies = { "saghen/blink.cmp" },
	},
	--{
	--	"nvim-tree/nvim-web-devicons", opts = {}
	--}
}
