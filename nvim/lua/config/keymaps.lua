-- Global keymaps (not plugin-dependent)
-- These are always available regardless of which plugins are loaded

local M = {}
-- g -- navigation (nvim native + gd lsp in telescope
-- <leader t> testing
-- <leader f> finding (stuff in telescope)
-- <leader a> arrange windows
-- <leader l> lsp interaction (except navigation)
-- <leader cc> ClaudeCode
-- TODO lsp default keys mappen (e.g :help grr und so)
function M.setup()
	-- Escape alternatives (German keyboard friendly)
	vim.keymap.set({ "i", "n", "v" }, "…", "<Esc>", { noremap = true, silent = true, desc = "Escape" })
	vim.keymap.set("c", "…", "<C-c>", { noremap = true, silent = true, desc = "Escape" })

	-- Terminal mappings
	vim.keymap.set("t", "<Esc>", "<Esc>")
	vim.keymap.set("t", "…", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

	-- Wildmenu navigation (command mode)
	vim.cmd([[
		cnoremap <expr> <up> wildmenumode() ? "\<left>" : "\<up>"
		cnoremap <expr> <down> wildmenumode() ? "\<right>" : "\<down>"
		cnoremap <expr> <left> wildmenumode() ? "\<up>" : "\<left>"
		cnoremap <expr> <right> wildmenumode() ? " \<bs>\<C-Z>" : 	"\<right>"
	]])

	--Window management
	vim.keymap.set("n", "<leader>a", "<C-w>", { remap = true, desc = "Window" })

	-- Move buffer to a window in the given direction
	local function move_buffer_to_direction(direction)
		local current_win = vim.api.nvim_get_current_win()
		local current_buf = vim.api.nvim_get_current_buf()

		-- Try to move to window in that direction
		vim.cmd("wincmd " .. direction)
		local target_win = vim.api.nvim_get_current_win()

		if target_win == current_win then
			-- No window in that direction, create a split
			local split_cmd = (direction == "h" or direction == "l") and "vsplit" or "split"
			if direction == "h" or direction == "k" then
				vim.cmd("leftabove " .. split_cmd)
			else
				vim.cmd("rightbelow " .. split_cmd)
			end
			target_win = vim.api.nvim_get_current_win()
		end

		-- Open current buffer in target window
		vim.api.nvim_win_set_buf(target_win, current_buf)

		-- Go back to original window and switch to previous buffer
		vim.api.nvim_set_current_win(current_win)
		vim.cmd("bprevious")

		-- Focus on target window
		vim.api.nvim_set_current_win(target_win)
	end

	local directions = {
		{ key = "<Right>", dir = "l", desc = "right" },
		{ key = "<Left>", dir = "h", desc = "left" },
		{ key = "<Up>", dir = "k", desc = "above" },
		{ key = "<Down>", dir = "j", desc = "below" },
	}

	for _, d in ipairs(directions) do
		vim.keymap.set("n", "<C-w>m" .. d.key, function()
			move_buffer_to_direction(d.dir)
		end, { noremap = true, silent = true, desc = "Move buffer to window " .. d.desc })
		vim.keymap.set("n", "<C-w>]" .. d.key, function()
			vim.lsp.buf.definition()
			move_buffer_to_direction(d.dir)
		end, { noremap = true, silent = true, desc = "Open definition on " .. d.desc })
	end
end

return M
