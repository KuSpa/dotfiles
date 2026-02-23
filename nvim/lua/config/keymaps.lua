-- Global keymaps (not plugin-dependent)
-- These are always available regardless of which plugins are loaded

local M = {}
-- g -- navigation (nvim native + gd lsp in telescope
-- <leader t> testing
-- <leader f> finding (stuff in telescope)
-- <leader a> arrange windows
-- <leader l> lsp interaction (except navigation)
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
	vim.keymap.set("n", "<leader>a", "<C-w>", { noremap = true, silent = true, desc = "Window" })
	-- TODO <C-w>] use horizontal split

	-- TODO vsplit with opening the buffer in a new window (default behavior) and falling back to the previous buffer in the origin window. (looks like a "move buffer")

	-- TODO (h)split same but horizontally
end

return M
