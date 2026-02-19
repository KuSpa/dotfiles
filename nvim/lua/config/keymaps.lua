-- Global keymaps (not plugin-dependent)
-- These are always available regardless of which plugins are loaded

local M = {}

function M.setup()
	-- Window management
	-- TODO: not really happy with this, because both is left hand and w for jump window is quite far away
	vim.keymap.set("n", "<TAB>", "<C-w>", { noremap = true, silent = true, desc = "Window prefix" })

	-- Escape alternatives (German keyboard friendly)
	vim.keymap.set({ "i", "n", "v" }, "ää", "<ESC>", { noremap = true, silent = true, desc = "Escape" })

	-- Terminal mappings
	vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
	vim.keymap.set("t", "ää", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

	-- Wildmenu navigation (command mode)
	vim.cmd([[
		cnoremap <expr> <up> wildmenumode() ? "\<left>" : "\<up>"
		cnoremap <expr> <down> wildmenumode() ? "\<right>" : "\<down>"
		cnoremap <expr> <left> wildmenumode() ? "\<up>" : "\<left>"
		cnoremap <expr> <right> wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"
	]])
end

return M
