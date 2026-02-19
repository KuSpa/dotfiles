-- LSP keybindings (buffer-local, only active when LSP is attached)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(args)
		local bufnr = args.buf
		local opts = function(desc)
			return { buffer = bufnr, noremap = true, silent = true, desc = desc }
		end

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
		vim.keymap.set("n", "grr", function()
			require("telescope.builtin").lsp_references()
		end, opts("References (Telescope)"))
		vim.keymap.set("n", "<leader>ge", vim.lsp.buf.code_action, opts("Code action"))
		vim.keymap.set("n", "<leader>gg", vim.lsp.buf.rename, opts("Rename"))
		vim.keymap.set("n", "g]", vim.diagnostic.goto_next, opts("Next diagnostic"))
		vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, opts("Prev diagnostic"))
	end,
})

return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"cssls",
				"html",
				"jsonls",
			},
			automatic_installation = true,
			handlers = {
				-- Default handler for all servers
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
				-- Custom handler for lua_ls
				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						settings = {
							Lua = {
								workspace = {
									checkThirdParty = false,
									library = vim.api.nvim_get_runtime_file("", true),
								},
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					})
				end,
			},
		},
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				-- TODO: <leader>f conflicts with <leader>ff, <leader>fg etc. (causes delay)
				-- Consider changing to <leader>cf or removing (format-on-save is enabled anyway)
				"<leader>f",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		---@module "conform"
		---@type conform.setupOpts
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				css = { "prettierd", "prettier", stop_after_first = true },
				scss = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				javascript = { "prettierd", "prettier", stop_after_first = true },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = { timeout_ms = 500 },
		},
	},
	{
		"hrsh7th/nvim-cmp",
		version = false,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		opts = function()
			vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
			local cmp = require("cmp")
			return {
				mapping = cmp.mapping.preset.insert({
					-- NOTE: <C-f> conflicts with toggleterm open_mapping
					-- Consider changing one of them if this causes issues
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-CR>"] = function(fallback)
						cmp.abort()
						fallback()
					end,
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
				}),
			}
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		lazy = false,
		init = function()
			vim.g.rustaceanvim = {
				server = {
					on_attach = function(client, bufnr)
						-- Rust-specific gd override: deduplicates definitions and uses Telescope for multiple
						vim.keymap.set("n", "gd", function()
							vim.lsp.buf.definition({
								on_list = function(options)
									local seen, items = {}, {}
									for _, item in ipairs(options.items) do
										local key = ("%s:%d:%d"):format(item.filename, item.lnum, item.col)
										if not seen[key] then
											seen[key] = true
											items[#items + 1] = item
										end
									end

									if #items == 1 then
										vim.cmd.edit(items[1].filename)
										vim.api.nvim_win_set_cursor(0, { items[1].lnum, items[1].col - 1 })
									else
										require("telescope.pickers")
											.new({}, {
												prompt_title = "Definitions",
												finder = require("telescope.finders").new_table({
													results = items,
													entry_maker = require("telescope.make_entry").gen_from_quickfix(),
												}),
												previewer = require("telescope.config").values.qflist_previewer({}),
												sorter = require("telescope.config").values.generic_sorter({}),
											})
											:find()
									end
								end,
							})
						end, { buffer = bufnr, desc = "Go to definition (Rust)" })
					end,
				},
			}
		end,
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		opts = {
			preview = { icon_provider = "devicons" },
		},
	},
}
