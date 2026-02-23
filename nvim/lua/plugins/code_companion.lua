return {
	"olimorris/codecompanion.nvim",
	version = "^18.0.0",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		interactions = {
			chat = {
				adapter = {
					name = "claude_code",
					model = "opus",
				},
			},
			inline = {
				adapter = "http_adapter",
			},
			cmd = {
				adapter = "http_adapter",
			},
			background = {
				adapter = "http_adapter",
			},
		},
		adapters = {
			acp = {
				claude_code = function()
					return require("codecompanion.adapters").extend("claude_code", {
						commands = {
							default = {
								"claude-agent-acp",
							},
						},
					})
				end,
			},
			http = {
				http_adapter = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = "FIX_MY_SETUP_PLS",
							api_key = "FOO_BAR_FANCY_PANTS",
							chat_url = "/v1/chat/completions",
						},
						opts = {
							stream = true,
						},
						schema = {
							model = {
								default = "gcp/claude-opus-4-5",
							},
						},
					})
				end,
			},
		},
	},
}
