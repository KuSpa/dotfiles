-- Claude Terminal Plugin
-- Provides a floating terminal for Claude Code with hot-reload support

-- Persistent terminal instance
local claude_term = nil

-- Toggle the Claude terminal
local function toggle_claude_term()
	local Terminal = require("toggleterm.terminal").Terminal

	if claude_term == nil then
		claude_term = Terminal:new({
			cmd = "claude",
			direction = "float",
			float_opts = {
				border = "curved",
				-- Functions ensure size adapts to window resizes
				width = function()
					return math.floor(vim.o.columns * 0.9)
				end,
				height = function()
					return math.floor(vim.o.lines * 0.9)
				end,
			},
			hidden = true,
			close_on_exit = false,
			on_open = function(term)
				-- Send raw <Esc> to terminal (ASCII 27 = escape)
				vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = term.bufnr, noremap = true, silent = true })
				vim.keymap.set("t", "…", [[<C-\><C-n>]], { buffer = term.bufnr, noremap = true, silent = true })
				vim.keymap.set("n", "…", function()
					claude_term:toggle()
				end, { buffer = term.bufnr, noremap = true, silent = true })

				-- Auto-enter insert mode when entering this terminal buffer
				vim.api.nvim_create_autocmd("BufEnter", {
					buffer = term.bufnr,
					callback = function()
						-- Defer to ensure we're the last thing to run
						vim.defer_fn(function()
							if vim.api.nvim_get_current_buf() == term.bufnr then
								vim.cmd("startinsert!")
							end
						end, 1)
					end,
				})
			end,
		})
	end

	claude_term:toggle()
end

return {
	{
		dir = vim.fn.stdpath("config") .. "/lua/plugins",
		name = "claude-term",
		dependencies = { "akinsho/toggleterm.nvim" },
		keys = {
			{
				"<leader>cc",
				toggle_claude_term,
				desc = "Toggle Claude Terminal (persistent)",
			},
		},
		config = function()
			local group = vim.api.nvim_create_augroup("ClaudeFileWatcher", { clear = true })
			local watchers = {}

			-- Enable autoread to detect external file changes
			vim.o.autoread = true

			-- Start watching a buffer's file
			local function watch_file(bufnr)
				local filepath = vim.api.nvim_buf_get_name(bufnr)
				if filepath == "" or watchers[filepath] then
					return
				end

				local handle = vim.loop.new_fs_event()
				if not handle then
					return
				end

				watchers[filepath] = handle

				handle:start(filepath, {}, function(err, filename, events)
					if err then
						return
					end
					-- Schedule to run in main loop
					vim.schedule(function()
						-- Check if buffer still exists and is valid
						if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_name(bufnr) == filepath then
							vim.cmd("checktime " .. bufnr)
						end
					end)
				end)
			end

			-- Stop watching a file
			local function unwatch_file(filepath)
				local handle = watchers[filepath]
				if handle then
					handle:stop()
					handle:close()
					watchers[filepath] = nil
				end
			end

			-- Watch files when buffers are opened
			vim.api.nvim_create_autocmd("BufReadPost", {
				group = group,
				pattern = "*",
				callback = function(args)
					watch_file(args.buf)
				end,
			})

			-- Stop watching when buffer is deleted
			vim.api.nvim_create_autocmd("BufDelete", {
				group = group,
				pattern = "*",
				callback = function(args)
					local filepath = vim.api.nvim_buf_get_name(args.buf)
					unwatch_file(filepath)
				end,
			})

			-- Watch already-open buffers
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(bufnr) then
					watch_file(bufnr)
				end
			end

			-- Notify when a file has been reloaded
			vim.api.nvim_create_autocmd("FileChangedShellPost", {
				group = group,
				pattern = "*",
				callback = function()
					local ok, notify = pcall(require, "notify")
					local notifier = ok and notify or vim.notify
					notifier("File reloaded: " .. vim.fn.expand("%:t"), vim.log.levels.INFO, {
						title = "Claude Code",
						timeout = 2000,
					})
				end,
			})
		end,
	},
}
