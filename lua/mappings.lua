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

-- Function to check buffer modification {{{
local function is_buffer_modified(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	-- Check if buffer is valid
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return false
	end
	-- Try multiple methods to check modification status
	local modified = false
	-- Method 1: vim.bo
	pcall(function()
		modified = vim.bo[bufnr].modified
	end)
	-- Method 2: Direct API call with fallback
	if not modified then
		pcall(function()
			-- Method to get modified status
			modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
		end)
	end
	return modified or false
end
-- }}}

-- Save buffer in Insert and Normal modes {{{
remap({ "i", "n" }, "<C-s>", function()
	local buffer_name = vim.fn.fnamemodify(vim.fn.bufname(), ":t")
	if is_buffer_modified() then
		vim.cmd("write")
		vim.notify("Buffer '" .. buffer_name .. "' saved", vim.log.levels.INFO, {
			timeout = 250,
		})
	else
		vim.notify("No changes to " .. buffer_name, vim.log.levels.WARN, {
			timeout = 250,
		})
	end
end, make_opt("Save buffer"))
-- }}}

-- Create a new empty buffer {{{
remap("n", "<leader>b", function()
	local current_buf = vim.api.nvim_get_current_buf()
	if is_buffer_modified(current_buf) then
		-- Use vim.ui.select for handling modified buffer
		vim.ui.select({ "Save and Create", "Create Without Saving", "Cancel" }, {
			prompt = "Current buffer has unsaved changes:",
		}, function(choice)
			if choice == "Save and Create" then
				-- Save current buffer
				vim.cmd("write")
				vim.cmd("enew")
				vim.notify("Saved and created new buffer", vim.log.levels.INFO, {
					timeout = 1500,
				})
			elseif choice == "Create Without Saving" then
				-- Create new buffer without saving
				vim.cmd("enew!")
				vim.notify("New buffer created without saving", vim.log.levels.WARN, {
					timeout = 1500,
				})
			else
				-- Cancel operation
				vim.notify("New buffer creation cancelled", vim.log.levels.INFO, {
					timeout = 1000,
				})
			end
		end)
	else
		-- If buffer is not modified, simply create a new buffer
		vim.cmd("enew")
		vim.notify("New buffer created", vim.log.levels.INFO, {
			timeout = 1000,
		})
	end
end, make_opt("new buffer"))
-- }}}

-- Close the current buffer {{{
remap("n", "<leader>x", function()
	local buf_modified = is_buffer_modified()
	local buffer_name = vim.fn.fnamemodify(vim.fn.bufname(), ":t")
	if buf_modified then
		-- Use vim.ui.select for confirmation
		vim.ui.select({ "Close Anyway", "Cancel" }, {
			prompt = "Buffer '" .. buffer_name .. "' has unsaved changes:",
			-- Simulate title-like behavior with a descriptive prompt
			kind = "buffer_close_confirmation",
		}, function(choice)
			if choice == "Close Anyway" then
				vim.cmd("bdelete!")
				vim.notify("Buffer '" .. buffer_name .. "' closed forcefully", vim.log.levels.WARN, {
					timeout = 1500,
				})
			else
				vim.notify("Buffer close cancelled", vim.log.levels.INFO, {
					timeout = 1000,
				})
			end
		end)
	else
		vim.cmd("bdelete")
		vim.notify("Buffer '" .. buffer_name .. "' closed", vim.log.levels.INFO, {
			timeout = 1000,
		})
	end
end, make_opt("close buffer"))
-- }}}

-- Close all buffers {{{
remap("n", "<leader>X", function()
	local modified_bufs = {}

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if is_buffer_modified(bufnr) then
			table.insert(modified_bufs, bufnr)
		end
	end

	if #modified_bufs > 0 then
		vim.ui.select({ "Yes", "No" }, {
			prompt = string.format("%d buffer(s) have unsaved changes. Close all?", #modified_bufs),
		}, function(choice)
			if choice == "Yes" then
				vim.cmd("%bdelete!")
				vim.notify(string.format("Closed %d buffers forcefully", #modified_bufs), vim.log.levels.WARN, {
					timeout = 2000,
				})
			else
				vim.notify("Close all buffers cancelled", vim.log.levels.INFO, {
					timeout = 1000,
				})
			end
		end)
	else
		vim.cmd("%bdelete")
		vim.notify("All buffers closed", vim.log.levels.INFO, {
			timeout = 1000,
		})
	end
end, make_opt("close all buffers"))
-- }}}

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
-- Copy selected text to system clipboard in visual mode
remap("v", "<C-c>", '"+y', make_opt("Copy selected text to system clipboard"))
-- Cut (delete and copy) selected text to system clipboard in visual mode
remap("v", "<C-x>", '"+d', make_opt("Cut selected text to system clipboard"))
-- Copy entire line to system clipboard
remap("n", "<S-c>", function()
	vim.cmd('normal! ^vg_"+y') -- Yank to system clipboard
end, make_opt("Copy entire line to system clipboard"))
-- Cut entire line to system clipboard
remap("n", "<S-x>", function()
	vim.cmd('normal! ^vg_"+d') -- Cut to system clipboard
end, make_opt("Cut entire line to system clipboard"))
-- Paste over selected text in both visual and normal mode
remap({ "v", "n" }, "<C-v>", '"+p', make_opt("Paste over selected text"))
-- Paste from system clipboard in insert mode
remap("i", "<C-v>", "<C-r>+", make_opt("Paste from system clipboard"))
-- Paste in visual mode without overwriting the current register
remap("v", "<S-v>", '"_dP', make_opt("Paste without overwriting register"))
-- Remap the 'y' and 'p' commands in visual mode
-- to preserve the cursor position
vim.cmd("vnoremap <silent> y y`]")
vim.cmd("vnoremap <silent> p p`]")
-- Remap the 'J' and 'K' commands in visual mode
-- to move the selected block up or down
remap("v", "J", ":m '>+1<CR>gv=gv", make_opt("move block up"))
remap("v", "K", ":m '<-2<CR>gv=gv", make_opt("move block down"))

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

-- nvim-cokeline {{{

-- Remap <Tab> to focus on the next buffer
remap("n", "<Tab>", "<Plug>(cokeline-focus-next)", make_opt("next buffer"))
-- Remap <S-Tab> (Shift + Tab) to focus on the previous buffer
remap("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", make_opt("previous buffer"))

-- }}}

-- telescope.nvim mappings {{{

-- Buffer list with Telescope
remap("n", "<leader>fb", function()
	require("telescope.builtin").buffers({
		sort_mru = true,
		ignore_current_buffer = true,
	})
end, make_opt("Buffer list"))

-- File browser with Telescope
remap("n", "<leader>ff", function()
	require("telescope").extensions.file_browser.file_browser({
		path = "%:p:h", -- Open in current file's directory
		select_buffer = true,
		grouped = true,
		hidden = true,
	})
end, make_opt("Find files"))

-- Old files (recently opened)
remap("n", "<leader>fo", function()
	require("telescope.builtin").oldfiles({
		only_cwd = true, -- Only show files from current working directory
	})
end, make_opt("Recently opened files"))

-- Frecency (frequency-based recent files)
remap("n", "<leader>fc", function()
	require("telescope").extensions.frecency.frecency({
		workspace = "CWD",
	})
end, make_opt("Recent files"))

-- Fuzzy find in current buffer
remap("n", "<Leader>fz", function()
	require("telescope.builtin").current_buffer_fuzzy_find({
		case_mode = "smart_case",
		previewer = false,
		layout_config = {
			width = 0.8,
			height = 0.6,
		},
	})
end, make_opt("Find in Buffer"))

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
remap("n", "<leader>dt", function()
	trouble_toggle("diagnostics")
end, make_opt("toggle global diagnostics"))
-- Toggle buffer-local diagnostics
remap("n", "<leader>db", function()
	trouble_toggle("diagnostics", {
		filter = { buf = 0 }, -- Focus on current buffer
	})
end, make_opt("toggle buffer diagnostics"))
-- Toggle symbols overview
remap("n", "<leader>ds", function()
	trouble_toggle("symbols", {
		focus = false,
	})
end, make_opt("toggle buffer symbols"))

-- }}}

-- session mappings - persisted.nvim {{{

-- Get session file name and session name
local get_session_names = function()
	local session_file_name = vim.fn.fnamemodify(vim.g.persisted_loaded_session, ":t")
	local clean_session_name = session_file_name:match(".*%%(.*)") or session_file_name
	return session_file_name, clean_session_name
end

-- Select session via Telescope
remap("n", "<A-s>", function()
	require("telescope").extensions.persisted.persisted({
		theme = "dropdown",
		sorting_strategy = "ascending",
		layout_config = {
			width = 0.3,
			height = 0.3,
			prompt_position = "bottom",
		},
	})
end, make_opt("Telescope Session Selection"))

-- Load last session
remap("n", "<A-l>", function()
	require("persisted").load({ last = true })
	local _, clean_session_name = get_session_names()
	vim.notify("Loading: " .. clean_session_name, vim.log.levels.INFO)
end, make_opt("load last session"))

-- Select session via Telescope (alternative mapping)
remap("n", "<leader>sS", function()
	require("telescope").extensions.persisted.persisted({
		theme = "dropdown",
		sorting_strategy = "ascending",
		layout_config = {
			width = 0.3,
			height = 0.4,
			prompt_position = "bottom",
		},
	})
end, make_opt("Telescope Session Selection"))

-- Save current session
remap("n", "<leader>ss", function()
	require("persisted").save()
	local _, clean_session_name = get_session_names()
	vim.notify("Session '" .. clean_session_name .. "' saved", vim.log.levels.INFO)
end, make_opt("Save Current Session"))

-- Load last session (alternative mapping)
remap("n", "<leader>sl", function()
	require("persisted").load({ last = true })
	local _, clean_session_name = get_session_names()
	vim.notify("Loading: " .. clean_session_name, vim.log.levels.INFO)
end, make_opt("Load Last Session"))

-- Stop current session
remap("n", "<leader>st", function()
	require("persisted").stop()
	local _, clean_session_name = get_session_names()
	vim.notify(clean_session_name .. " stopped", vim.log.levels.INFO)
end, make_opt("Stop Current Session"))

-- search and replace - nvim-spectre {{{
--
-- Toggle Spectre search/replace
remap("n", "<leader>R", function()
	require("spectre").toggle()
end, make_opt("Search and rplace"))
-- Search current word globally
remap("n", "<leader>rw", function()
	require("spectre").open_visual({
		select_word = true,
	})
end, make_opt("Search current word"))
-- Search current word in current file
remap("n", "<leader>rp", function()
	require("spectre").open_file_search({
		select_word = true,
	})
end, make_opt("Search word on current file"))

-- }}}

-- search and replace - searchbox.nvim {{{

-- Incremental Search
remap("n", "<leader>si", function()
	require("searchbox").incsearch({
		title = "Incremental Search",
		exact = true,
	})
end, make_opt("search (incremental)"))

-- Search Match All
remap("n", "<leader>sa", function()
	require("searchbox").match_all({
		title = "Search Match All",
		exact = true,
	})
end, make_opt("search (match all)"))

-- Search and Replace
remap("n", "<leader>sr", function()
	require("searchbox").replace({
		title = "Search and Replace",
		exact = true,
		confirm = "menu",
	})
end, make_opt("search and replace"))

-- }}}

-- diffview.nvim mappings {{{

-- Open Diffview for comparing current changes
remap("n", "<leader>dv", function()
	vim.cmd("DiffviewOpen")
end, make_opt("Diffview - Compare all changes"))

-- Open file history for the entire repository
remap("n", "<leader>dh", function()
	vim.cmd("DiffviewFileHistory")
end, make_opt("Diffview repository history"))

-- Open file history for the current buffer
remap("n", "<leader>df", function()
	vim.cmd("DiffviewFileHistory %")
end, make_opt("Diffview current file history"))

-- Close the active Diffview window
remap("n", "<leader>dc", function()
	vim.cmd("DiffviewClose")
end, make_opt("Close Diffview"))

-- Open diff for staged changes
remap("n", "<leader>dH", function()
	vim.cmd("DiffviewOpen HEAD")
end, make_opt("Diffview Compare staged with HEAD"))

-- }}}

-- git mappings {{{

-- Open Neogit for workspace
remap("n", "<leader>gm", function()
	require("neogit").open()
end, make_opt("git manager (workspace)"))
-- Open Neogit for current buffer's directory
remap("n", "<leader>gM", function()
	require("neogit").open({
		cwd = vim.fn.expand("%:p:h"), -- Current buffer's directory
	})
end, make_opt("git manager (buffer)"))
-- Git commits history via Telescope
remap("n", "<leader>gh", function()
	require("telescope.builtin").git_commits()
end, make_opt("git commits history"))
-- Git commits for current buffer via Telescope
remap("n", "<leader>gb", function()
	require("telescope.builtin").git_bcommits()
end, make_opt("git commits buffer"))

-- }}}

-- Toggle terminal mappings {{{
--
-- Mapping for toggling terminal in horizontal mode
remap({ "n", "i", "t" }, "<a-t>", function()
	require("toggleterm").toggle(0, nil, nil, "horizontal")
end, make_opt("Toggle Terminal (Horizontal)"))

-- Mapping for toggling terminal in vertical mode
remap({ "n", "i", "t" }, "<a-v>", function()
	require("toggleterm").toggle(0, nil, nil, "vertical")
end, make_opt("Toggle Terminal (Vertical)"))

-- Mapping for toggling terminal in float mode
remap({ "n", "i", "t" }, "<a-f>", function()
	require("toggleterm").toggle(0, nil, nil, "float")
end, make_opt("Toggle Terminal (Float)"))

-- Mapping to exit terminal mode using Esc
remap("t", "jk", [[<C-\><C-n>]], make_opt("Exit Terminal Mode"))

-- }}}

-- fidget.nvim mappings {{{
remap("n", "<leader>lg", function()
	require("telescope").extensions.fidget.fidget({
		sorting_strategy = "ascending",
		layout_config = {
			width = 0.8,
			height = 0.4,
			prompt_position = "bottom",
		},
	})
end, make_opt("Check messages"))

--}}}
