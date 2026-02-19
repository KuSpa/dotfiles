return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-neotest/neotest-jest",
		"mrcjkb/rustaceanvim", -- For Rust test adapter
		"marilari88/neotest-vitest", -- For Vitest/Bun adapter
	},
	keys = {
		{
			"<leader>tt",
			function()
				require("neotest").run.run()
			end,
			desc = "Run nearest test",
		},
		{
			"<leader>tf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Run current file",
		},
		{
			"<leader>ta",
			function()
				require("neotest").run.run(vim.fn.getcwd())
			end,
			desc = "Run all tests",
		},
		{
			"<leader>ts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Toggle test summary",
		},
		{
			"<leader>to",
			function()
				require("neotest").output.open({ enter = true })
			end,
			desc = "Show test output",
		},
		{
			"<leader>tp",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "Toggle output panel",
		},
		{
			"<leader>tx",
			function()
				require("neotest").run.stop()
			end,
			desc = "Stop test",
		},
		{
			"<leader>tw",
			function()
				require("neotest").watch.toggle(vim.fn.expand("%"))
			end,
			desc = "Toggle watch mode",
		},
	},
	config = function()
		require("neotest").setup({
			adapters = {
				-- Jest adapter for JavaScript/TypeScript
				require("neotest-jest")({
					jestCommand = function()
						local cwd = vim.fn.getcwd()
						-- Check for bun.lockb to use bun
						if vim.fn.filereadable(cwd .. "/bun.lockb") == 1 then
							return "bun run test"
						elseif vim.fn.filereadable(cwd .. "/pnpm-lock.yaml") == 1 then
							return "pnpm test"
						elseif vim.fn.filereadable(cwd .. "/yarn.lock") == 1 then
							return "yarn test"
						elseif vim.fn.filereadable(cwd .. "/package-lock.json") == 1 then
							return "npm test --"
						end
						-- Fallback to npx jest
						return "npx jest"
					end,
					cwd = function(path)
						return vim.fn.getcwd()
					end,
				}),
				-- Vitest adapter for Vite/Bun projects
				require("neotest-vitest")({
					vitestCommand = function()
						-- Check for bun.lockb to use bun
						if vim.fn.filereadable(vim.fn.getcwd() .. "/bun.lockb") == 1 then
							return "bun run vitest"
						elseif vim.fn.filereadable(vim.fn.getcwd() .. "/pnpm-lock.yaml") == 1 then
							return "pnpm exec vitest"
						elseif vim.fn.filereadable(vim.fn.getcwd() .. "/yarn.lock") == 1 then
							return "yarn vitest"
						end
						-- Fallback to npx vitest
						return "npx vitest"
					end,
				}),
				-- Rust adapter via rustaceanvim
				require("rustaceanvim.neotest"),
			},
			status = { virtual_text = true },
			output = { open_on_run = true },
			quickfix = {
				open = function()
					vim.cmd("copen")
				end,
			},
		})
	end,
}
