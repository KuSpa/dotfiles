-- Use <SPACE> as leader
vim.keymap.set("n", " ", "<nop>", { silent = true, remap = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable mouse, bc i am a sick h4ck0r
vim.opt.mouse = ""

require("config.lazy")
require("telescope").load_extension("file_browser")

vim.diagnostic.enable()
vim.diagnostic.config({
	virtual_text = true,
	update_in_insert = true,
})

-- Telescope Keybundings
-- TODO Copy/Paste validate
local function live_grep_from_project_git_root()
	local function is_git_repo()
		vim.fn.system("git rev-parse --is-inside-work-tree")
		return vim.v.shell_error == 0
	end

	local function get_git_root()
		local dot_git_path = vim.fn.finddir(".git", ".;")
		return vim.fn.fnamemodify(dot_git_path, ":h")
	end

	local opts = {}

	if is_git_repo() then
		opts = {
			cwd = get_git_root(),
		}
	end

	require("telescope.builtin").live_grep(opts)
end

-- TODO Copy/Paste validate
local function find_files_from_project_git_root()
	local function is_git_repo()
		vim.fn.system("git rev-parse --is-inside-work-tree")
		return vim.v.shell_error == 0
	end
	local function get_git_root()
		local dot_git_path = vim.fn.finddir(".git", ".;")
		return vim.fn.fnamemodify(dot_git_path, ":h")
	end
	local opts = {}
	if is_git_repo() then
		opts = {
			cwd = get_git_root(),
		}
	end
	require("telescope.builtin").find_files(opts)
end

-- <LEADER> F for finding things
-- TODO curently <leader> f is also formaut buffer, but i never use this shortcut, as :w is as fast ;)
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", find_files_from_project_git_root, { desc = "Telescope find files (customized)" })
vim.keymap.set("n", "<leader>fg", live_grep_from_project_git_root, { desc = "Telescope live grep (customized)" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fd", function()
	require("telescope.builtin").diagnostics()
end, {})
vim.keymap.set(
	"n",
	"<leader>fn",
	":Telescope file_browser path=%:p:h select_buffer=true<CR>",
	{ desc = "Telescope file navigation" }
)

-- LSP Keybindings that need a little love as well
vim.keymap.set("n", "grr", function()
	require("telescope.builtin").lsp_references()
end, { noremap = true, silent = true })
-- TODO not really happy with this, because both is left hand and w for jump window is quite far away. Probably gonna hardcode window management
vim.keymap.set("n", "<TAB>", "<C-w>", { noremap = true, silent = true })
vim.keymap.set({ "i", "n", "v" }, "ää", "<ESC>", { noremap = true, silent = true })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])
vim.keymap.set("t", "ää", [[<C-\><C-n>]])

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.relativenumber = true
vim.cmd([[
cnoremap <expr> <up> wildmenumode() ? "\<left>" : "\<up>"
cnoremap <expr> <down> wildmenumode() ? "\<right>" : "\<down>"
cnoremap <expr> <left> wildmenumode() ? "\<up>" : "\<left>"
cnoremap <expr> <right> wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"
]])

--[[local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = "",
	}
	vim.lsp.buf.execute_command(params)
end

lspconfig.tsserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	commands = {
		OrganizeImports = {
			organize_imports,
			description = "Organize Imports",
		},
	},
})]]

vim.opt.showmode = false
