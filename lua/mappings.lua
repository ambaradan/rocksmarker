-- Rocksmarker mappings

-- Remap function to set key mapping
local remap = function(mode, lhs, rhs, opts)
	pcall(vim.keymap.del, mode, lhs)
	return vim.keymap.set(mode, lhs, rhs, opts)
end
-- Function to create default options for key mappings
local make_opt = function(desc)
	return {
		silent = true, -- Suppress command output
		noremap = true, -- Prevent recursive remapping
		desc = desc, -- Description for the mapping
	}
end

-- Buffer mappings {{{

-- Save buffer in Insert and Normal modes
remap({ "i", "n" }, "<C-s>", "<cmd>w<cr>", make_opt(" Save buffer"))
-- Create a new empty buffer
remap("n", "<leader>b", "<cmd>enew<cr>", make_opt("new buffer"))
-- Close the current buffer
remap("n", "<leader>x", "<cmd>bd<cr>", make_opt("close buffer"))
-- Close all buffers - needed to change session
remap("n", "<leader>X", "<cmd>%bd<cr>", make_opt("close all buffers"))

-- }}}

-- Editor mappings {{{

-- Remap <leader>q to quit the current buffer/window
remap("n", "<leader>q", "<cmd>q<cr>", make_opt("quit editor"))
-- Remap <Esc> to clear search highlights
-- Useful after searching to remove highlight remnants
remap("n", "<Esc>", "<cmd>noh<CR>", make_opt("clear highlights"))
-- Remap ',' to open Telescope cmdline
-- Provides quick access to command-line interface via Telescope
remap("n", ",", "<cmd>Telescope cmdline<cr>", make_opt("cmdline line"))
-- conform - manual formatting
remap("n", "<leader>F", function()
	require("conform").format({ lsp_fallback = true })
end, make_opt("format buffer"))

-- }}}

-- neo-tree.nvim mappings {{{

-- Toggle Neo-tree File Explorer in a floating window
remap("n", ".", function()
	require("neo-tree.command").execute({ toggle = true, position = "float", dir = vim.fn.getcwd() })
end, make_opt("Neo-tree File Explorer (float)"))
-- Toggle Neo-tree File Explorer in a right window
remap("n", "<C-n>", function()
	require("neo-tree.command").execute({ toggle = true, position = "right", source = "filesystem" })
end, make_opt("Neo-tree File Explorer (right)"))
-- Reveal current file in Neo-tree filesystem
remap("n", "<leader>fr", function()
	require("neo-tree.command").execute({
		reveal = true,
		toggle = true,
		position = "float",
		source = "filesystem",
	})
end, make_opt("Reveal File in workspace"))

-- }}}

-- nvim-cokeline
-- Remap <Tab> to focus on the next buffer
remap("n", "<Tab>", "<Plug>(cokeline-focus-next)", make_opt("next buffer"))
-- Remap <S-Tab> (Shift + Tab) to focus on the previous buffer
remap("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", make_opt("previous buffer"))

-- Yank mappings commands {{{
remap({ "n", "i" }, "<A-y>", "<cmd>Telescope yank_history theme=dropdown<cr>", make_opt("yank history"))
-- Preserve clipboard content when pasting over selected text
remap("x", "<leader>p", '"_dP', make_opt(" Paste without overwriting clipboard"))
-- Yank to system clipboard
remap({ "n", "v" }, "<A-c>", '"+y', make_opt(" Yank to system clipboard"))
remap("n", "<leader>Y", '"+Y', make_opt(" Yank line to system clipboard"))
-- Delete to void register (prevent clipboard pollution)
remap({ "n", "v" }, "<leader>d", '"_d', make_opt("Delete to void register"))
-- Paste from system clipboard in insert and command mode
remap({ "i", "c" }, "<A-v>", "<C-r>+", make_opt(" Paste from system clipboard in insert mode"))
-- }}}

-- telescope.nvim mappings {{{
remap("n", "<leader>tb", "<cmd>Telescope buffers<cr>", make_opt("buffer list"))
remap("n", "<leader>tf", "<cmd>Telescope file_browser<cr>", make_opt("find files"))
remap("n", "<leader>to", "<cmd>Telescope oldfiles<cr>", make_opt("find files"))
remap("n", "<leader>tr", "<cmd>Telescope frecency theme=ivy<cr>", make_opt("recent files"))
remap(
	"n",
	"<Leader>ts",
	"<cmd>Telescope current_buffer_fuzzy_find case_mode=smart_case<CR>",
	make_opt("Find in Buffer")
)
-- }}}

-- trouble.nvim {{{
-- Toggle global diagnostics
remap("n", "<leader>dt", "<cmd>Trouble diagnostics toggle<cr>", make_opt("global diagnostics"))
-- Toggle buffer-local diagnostics
remap("n", "<leader>db", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", make_opt("buffer diagnostics"))
-- Toggle symbols overview
remap("n", "<leader>ds", "<cmd>Trouble symbols toggle focus=false<cr>", make_opt("buffer symbols"))
-- }}}

-- session mappings - persisted.nvim {{{
remap("n", "<A-s>", "<cmd>Telescope persisted theme=dropdown<cr>", make_opt("select session"))
remap("n", "<A-l>", "<cmd>SessionLoadLast<cr>", make_opt("load last session"))
remap("n", "<leader>sS", "<cmd>Telescope persisted<cr>", make_opt("select session"))
remap("n", "<leader>ss", "<cmd>SessionSave<cr>", make_opt("save current session"))
remap("n", "<leader>sl", "<cmd>SessionLoadLast<cr>", make_opt("load session"))
remap("n", "<leader>st", "<cmd>SessionStop<cr>", make_opt("stop current session"))
-- }}}

-- search and replace - spectre {{{
remap("n", "<leader>R", '<cmd>lua require("spectre").toggle()<cr>', make_opt("search/replace"))
remap(
	"n",
	"<leader>rw",
	'<cmd>lua require("spectre").open_visual({select_word=true})<cr>',
	make_opt("Search current word")
)
remap(
	"n",
	"<leader>rp",
	'<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
	make_opt("Search on current file")
)
-- }}}

-- search and replace - searchbox.nvim {{{
remap(
	"n",
	"<leader>si",
	"<cmd>SearchBoxIncSearch title=' Incremental Search' exact=true<cr>",
	make_opt("search (incremental)")
)
remap(
	"n",
	"<leader>sa",
	"<cmd>SearchBoxMatchAll title=' Search Match All' exact=true<cr>",
	make_opt("search (match all)")
)
remap(
	"n",
	"<leader>sr",
	"<cmd>SearchBoxReplace title=' Search and Replace' exact=true confirm=menu<cr>",
	make_opt("search and replace")
)
-- }}}

-- diffview.nvim mappings {{{
remap("n", "<leader>dv", "<cmd>DiffviewOpen<cr>", make_opt("diffview file"))
remap("n", "<leader>dh", "<cmd>DiffviewFileHistory<cr>", make_opt("diffview history"))
remap("n", "<leader>df", "<cmd>DiffviewFileHistory %<cr>", make_opt("diffview file history"))
remap("n", "<leader>dc", "<cmd>DiffviewClose<cr>", make_opt("diffview close"))
-- }}}

-- git mappings {{{
remap("n", "<leader>gm", "<cmd>Neogit<cr>", make_opt("git manager (workspace)"))
remap("n", "<leader>gM", "<cmd>Neogit cwd=%:p:h<cr>", make_opt("git manager (buffer)"))
-- remap("n", "<leader>gc", "<cmd>Neotree git_status bottom<cr>", make_opt("neo-tree git status"))
remap("n", "<leader>gh", "<cmd>Telescope git_commits<cr>", make_opt("git commits history"))
remap("n", "<leader>gb", "<cmd>Telescope git_bcommits<cr>", make_opt("git commits buffer"))
-- }}}

-- Remap the 'y' and 'p' commands in visual mode
-- to preserve the cursor position
vim.cmd("vnoremap <silent> y y`]")
vim.cmd("vnoremap <silent> p p`]")

-- Remap the 'J' and 'K' commands in visual mode
-- to move the selected block up or down
remap("v", "J", ":m '>+1<CR>gv=gv", make_opt("move block up"))
remap("v", "K", ":m '<-2<CR>gv=gv", make_opt("move block down"))
