-- Use <SPACE> as leader
vim.keymap.set("n", " ", "<nop>", { silent = true, remap = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable mouse, bc i am a sick h4ck0r
vim.opt.mouse = ""

require("config.lazy")
require("config.keymaps").setup()

vim.diagnostic.enable()
vim.diagnostic.config({
	virtual_text = true,
	update_in_insert = true,
	float = { border = "rounded" },
})

-- Global floating window border (Neovim 0.10+)
vim.o.winborder = "rounded"

-- Editor options
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.relativenumber = true
vim.opt.showmode = false

-- Filetype specific settings
vim.cmd([[autocmd FileType markdown setlocal spell spelllang=en_us]])
