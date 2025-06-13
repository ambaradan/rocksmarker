-- Rocksmarker mappings
local editor = require("utils.editor")
-- local mkdocs = require("utils.mkdocs.server")

-- Buffer mappings {{{

-- Save buffer in Insert and Normal modes
editor.remap({ "i", "n" }, "<C-s>", function()
	editor.save_current_buffer()
end, editor.make_opt("Save buffer"))
-- Create a new empty buffer
editor.remap("n", "<leader>b", function()
	editor.create_new_buffer()
end, editor.make_opt("new buffer"))
-- Close the current buffer
editor.remap("n", "<leader>x", function()
	editor.close_current_buffer()
end, editor.make_opt("close buffer"))
-- Close all buffers
editor.remap("n", "<leader>X", function()
	editor.close_all_buffers()
end, editor.make_opt("close all buffers"))

-- }}}

-- Editor mappings {{{

-- Remap <leader>q to quit the current buffer/window
editor.remap("n", "<leader>q", "<cmd>q<cr>", editor.make_opt("quit editor"))
-- Remap <Esc> to clear search highlights
-- Useful after searching to remove highlight remnants
editor.remap("n", "<Esc>", "<cmd>noh<CR>", editor.make_opt("clear highlights"))
-- Remap ',' to open Telescope cmdline
-- Provides quick access to command-line interface via Telescope
editor.remap("n", ",", "<cmd>Telescope cmdline<cr>", editor.make_opt("cmdline line"))
-- conform - manual formatting
editor.remap("n", "<leader>F", function()
	require("conform").format({ lsp_fallback = true })
end, editor.make_opt("format buffer"))
-- Copy selected text to system clipboard in visual mode
editor.remap("v", "<C-c>", '"+y', editor.make_opt("Copy selected text to system clipboard"))
-- Cut (delete and copy) selected text to system clipboard in visual mode
editor.remap("v", "<C-x>", '"+d', editor.make_opt("Cut selected text to system clipboard"))
-- Copy entire line to system clipboard
editor.remap("n", "<S-c>", function()
	vim.cmd('normal! ^vg_"+y') -- Yank to system clipboard
end, editor.make_opt("Copy entire line to system clipboard"))
-- Cut entire line to system clipboard
editor.remap("n", "<S-x>", function()
	vim.cmd('normal! ^vg_"+d') -- Cut to system clipboard
end, editor.make_opt("Cut entire line to system clipboard"))
-- Paste over selected text in both visual and normal mode
editor.remap({ "v", "n" }, "<C-v>", '"+p', editor.make_opt("Paste over selected text"))
-- Paste from system clipboard in insert mode
editor.remap("i", "<C-v>", "<C-r>+", editor.make_opt("Paste from system clipboard"))
-- Paste in visual mode without overwriting the current register
editor.remap("v", "<S-v>", '"_dP', editor.make_opt("Paste without overwriting register"))
-- Remap the 'y' and 'p' commands in visual mode
-- to preserve the cursor position
vim.cmd("vnoremap <silent> y y`]")
vim.cmd("vnoremap <silent> p p`]")
-- Remap the 'J' and 'K' commands in visual mode
-- to move the selected block up or down
editor.remap("v", "J", ":m '>+1<CR>gv=gv", editor.make_opt("move block up"))
editor.remap("v", "K", ":m '<-2<CR>gv=gv", editor.make_opt("move block down"))
-- Diagnostics toggle
editor.remap("n", "<leader>dd", function()
	editor.toggle_diagnostic_virtual_text()
end, editor.make_opt("Toggle Diagnostics"))

-- }}}

-- neo-tree.nvim mappings {{{

-- Toggle Neo-tree File Explorer in a floating window
editor.remap("n", ".", function()
	require("neo-tree.command").execute({ toggle = true, position = "float", dir = vim.fn.getcwd() })
end, editor.make_opt("Neo-tree File Explorer (float)"))
-- Toggle Neo-tree File Explorer in a right window
editor.remap("n", "<C-n>", function()
	require("neo-tree.command").execute({ toggle = true, position = "right", source = "filesystem" })
end, editor.make_opt("Neo-tree File Explorer (right)"))
-- Reveal current file in Neo-tree filesystem
editor.remap("n", "<leader>fr", function()
	require("neo-tree.command").execute({
		reveal = true,
		toggle = true,
		position = "float",
		source = "filesystem",
	})
end, editor.make_opt("Reveal File in workspace"))

-- }}}

-- bufferline.nvim mappings {{{

editor.remap("n", "<leader>bp", ":BufferLinePick<CR>", editor.make_opt("Buffer Line Pick"))
editor.remap("n", "<leader>bc", ":BufferLinePickClose<CR>", editor.make_opt("Buffer Line Pick Close"))
editor.remap("n", "<TAB>", ":BufferLineCycleNext<CR>", editor.make_opt("Buffer Line Cycle Next"))
editor.remap("n", "<S-TAB>", ":BufferLineCyclePrev<CR>", editor.make_opt("Buffer Line Cycle Prev"))

-- }}}

-- telescope.nvim mappings {{{

-- Buffer list with Telescope
editor.remap("n", "<leader>fb", function()
	require("telescope.builtin").buffers({
		sort_mru = true,
		ignore_current_buffer = true,
	})
end, editor.make_opt("Buffer list"))

-- File browser with Telescope
editor.remap("n", "<leader>ff", function()
	require("telescope").extensions.file_browser.file_browser({
		path = "%:p:h", -- Open in current file's directory
		select_buffer = true,
		grouped = true,
		hidden = true,
	})
end, editor.make_opt("Find files"))

-- Old files (recently opened)
editor.remap("n", "<leader>fo", function()
	require("telescope.builtin").oldfiles({
		only_cwd = true, -- Only show files from current working directory
	})
end, editor.make_opt("Recently opened files"))

-- Frecency (frequency-based recent files)
editor.remap("n", "<leader>fc", function()
	require("telescope").extensions.frecency.frecency({
		workspace = "CWD",
	})
end, editor.make_opt("Recent files"))

-- Undo (undo operations on file)
editor.remap("n", "<leader>fu", function()
	require("telescope").extensions.undo.undo({})
end, editor.make_opt("Undo operations"))

-- Fuzzy find in current buffer
editor.remap("n", "<Leader>fz", function()
	require("telescope.builtin").current_buffer_fuzzy_find({
		case_mode = "smart_case",
		previewer = false,
		layout_config = {
			width = 0.8,
			height = 0.6,
		},
	})
end, editor.make_opt("Find in Buffer"))

-- }}}

-- trouble.nvim {{{

-- Create a toggle function for Trouble
local function trouble_toggle(mode, opts)
	opts = opts or {}
	local trouble = require("trouble")

	-- Check if Trouble is already open
	if trouble.is_open() then
		trouble.close()
	else
		trouble.open(mode, opts)
	end
end

-- Toggle global diagnostics
editor.remap("n", "<leader>dt", function()
	trouble_toggle("diagnostics")
end, editor.make_opt("toggle global diagnostics"))
-- Toggle buffer-local diagnostics
editor.remap("n", "<leader>db", function()
	trouble_toggle("diagnostics", {
		filter = { buf = 0 }, -- Focus on current buffer
	})
end, editor.make_opt("toggle buffer diagnostics"))
-- Toggle symbols overview
editor.remap("n", "<leader>ds", function()
	trouble_toggle("symbols", {
		focus = false,
	})
end, editor.make_opt("toggle buffer symbols"))

-- }}}

-- session mappings - persisted.nvim {{{

-- Import the get_session_names function
local get_session_names = editor.get_session_names

-- Select session via Telescope
editor.remap("n", "<A-s>", function()
	require("telescope").extensions.persisted.persisted({
		theme = "dropdown",
		sorting_strategy = "ascending",
		layout_config = {
			width = 0.3,
			height = 0.3,
			prompt_position = "bottom",
		},
	})
end, editor.make_opt("Telescope Session Selection"))

-- Load last session
editor.remap("n", "<A-l>", function()
	require("persisted").load({ last = true })
	local _, clean_session_name = get_session_names()
	vim.notify("Loading: " .. clean_session_name, vim.log.levels.INFO)
end, editor.make_opt("load last session"))

-- Select session via Telescope (alternative mapping)
editor.remap("n", "<leader>sS", function()
	require("telescope").extensions.persisted.persisted({
		theme = "dropdown",
		sorting_strategy = "ascending",
		layout_config = {
			width = 0.3,
			height = 0.4,
			prompt_position = "bottom",
		},
	})
end, editor.make_opt("Telescope Session Selection"))

-- Save current session
editor.remap("n", "<leader>ss", function()
	require("persisted").save()
	local _, clean_session_name = get_session_names()
	vim.notify("Session '" .. clean_session_name .. "' saved", vim.log.levels.INFO)
end, editor.make_opt("Save Current Session"))

-- Load last session (alternative mapping)
editor.remap("n", "<leader>sl", function()
	require("persisted").load({ last = true })
	local _, clean_session_name = get_session_names()
	vim.notify("Loading: " .. clean_session_name, vim.log.levels.INFO)
end, editor.make_opt("Load Last Session"))

-- Stop current session
editor.remap("n", "<leader>st", function()
	require("persisted").stop()
	local _, clean_session_name = get_session_names()
	vim.notify(clean_session_name .. " stopped", vim.log.levels.INFO)
end, editor.make_opt("Stop Current Session"))

-- }}}

-- search and replace - nvim-spectre {{{
--
-- Toggle Spectre search/replace
editor.remap("n", "<leader>R", function()
	require("spectre").toggle()
end, editor.make_opt("Search and rplace"))
-- Search current word globally
editor.remap("n", "<leader>rw", function()
	require("spectre").open_visual({
		select_word = true,
	})
end, editor.make_opt("Search current word"))
-- Search current word in current file
editor.remap("n", "<leader>rp", function()
	require("spectre").open_file_search({
		select_word = true,
	})
end, editor.make_opt("Search word on current file"))

-- }}}

-- search and replace - searchbox.nvim {{{

-- Incremental Search
editor.remap("n", "<leader>si", function()
	require("searchbox").incsearch({
		title = "Incremental Search",
		exact = true,
	})
end, editor.make_opt("search (incremental)"))

-- Search Match All
editor.remap("n", "<leader>sa", function()
	require("searchbox").match_all({
		title = "Search Match All",
		exact = true,
	})
end, editor.make_opt("search (match all)"))

-- Search and Replace
editor.remap("n", "<leader>sr", function()
	require("searchbox").replace({
		title = "Search and Replace",
		exact = true,
		confirm = "menu",
	})
end, editor.make_opt("search and replace"))

-- }}}

-- diffview.nvim mappings {{{

-- Open Diffview for comparing current changes
editor.remap("n", "<leader>dv", function()
	vim.cmd("DiffviewOpen")
end, editor.make_opt("Diffview - Compare all changes"))

-- Open file history for the entire repository
editor.remap("n", "<leader>dh", function()
	vim.cmd("DiffviewFileHistory")
end, editor.make_opt("Diffview repository history"))

-- Open file history for the current buffer
editor.remap("n", "<leader>df", function()
	vim.cmd("DiffviewFileHistory %")
end, editor.make_opt("Diffview current file history"))

-- Close the active Diffview window
editor.remap("n", "<leader>dc", function()
	vim.cmd("DiffviewClose")
end, editor.make_opt("Close Diffview"))

-- Open diff for staged changes
editor.remap("n", "<leader>dH", function()
	vim.cmd("DiffviewOpen HEAD")
end, editor.make_opt("Diffview Compare staged with HEAD"))

-- }}}

-- git mappings {{{

-- Open Neogit for workspace
editor.remap("n", "<leader>gm", function()
	require("neogit").open()
end, editor.make_opt("git manager (workspace)"))
-- Open Neogit for current buffer's directory
editor.remap("n", "<leader>gM", function()
	require("neogit").open({
		cwd = vim.fn.expand("%:p:h"), -- Current buffer's directory
	})
end, editor.make_opt("git manager (buffer)"))
-- Git commits history via Telescope
editor.remap("n", "<leader>gh", function()
	require("telescope.builtin").git_commits()
end, editor.make_opt("git commits history"))
-- Git commits for current buffer via Telescope
editor.remap("n", "<leader>gb", function()
	require("telescope.builtin").git_bcommits()
end, editor.make_opt("git commits buffer"))

-- }}}

-- Toggle terminal mappings {{{
--
-- Mapping for toggling terminal in horizontal mode
editor.remap({ "n", "i", "t" }, "<a-t>", function()
	require("toggleterm").toggle(0, nil, nil, "horizontal")
end, editor.make_opt("Toggle Terminal (Horizontal)"))

-- Mapping for toggling terminal in vertical mode
editor.remap({ "n", "i", "t" }, "<a-v>", function()
	require("toggleterm").toggle(0, nil, nil, "vertical")
end, editor.make_opt("Toggle Terminal (Vertical)"))

-- Mapping for toggling terminal in float mode
editor.remap({ "n", "i", "t" }, "<a-f>", function()
	require("toggleterm").toggle(0, nil, nil, "float")
end, editor.make_opt("Toggle Terminal (Float)"))

-- Mapping to exit terminal mode using Esc
editor.remap("t", "jk", [[<C-\><C-n>]], editor.make_opt("Exit Terminal Mode"))

-- }}}

-- fidget.nvim mappings {{{
editor.remap("n", "<leader>lg", function()
	require("telescope").extensions.fidget.fidget({
		sorting_strategy = "ascending",
		layout_config = {
			width = 0.8,
			height = 0.4,
			prompt_position = "bottom",
		},
	})
end, editor.make_opt("Check messages"))

--}}}

-- MkDocs Libs mappings {{{

-- editor.remap("n", "<leader>mr", function()
-- 	mkdocs.serve()
-- end, editor.make_opt("Serve MkDocs"))
--
-- editor.remap("n", "<leader>mx", function()
-- 	mkdocs.stop_serve()
-- end, editor.make_opt("Stop MkDocs"))
--
-- editor.remap("n", "<leader>ms", function()
-- 	mkdocs.mkdocs_status()
-- end, editor.make_opt("Status MkDocs"))
--
-- }}}
