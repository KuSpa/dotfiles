return {

	"nvim-neotest/neotest",
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter",
			lazy = false,
			branch = "main",
			build = ":TSUpdate",
			opts = { ensure_installed = { "javascript", "typescript" }, auto_install = true },
		},
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-neotest/neotest-jest",
	},

	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-jest")({
					jestCommand = "npm test --",
					jestArguments = function(defaultArguments, context)
						return defaultArguments
					end,
					jestConfigFile = "jest.config.ts",
					cwd = function(path)
						return vim.fn.getcwd()
					end,
					isTestFile = require("neotest-jest.jest-util").defaultIsTestFile,
				}),
			},
		})
	end,
}
