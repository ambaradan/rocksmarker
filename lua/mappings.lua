-- Rocksmarker mappings

local map = vim.keymap.set
local map_opts = { noremap = true, silent = true }

-- main commands {{{
map("n", "<leader>q", "<cmd>q<cr>", { desc = "quit editor" })
map({ "i", "n" }, "<C-s>", "<cmd>w<cr>", map_opts) -- save buffer
map("n", "<leader>s", function()
	vim.cmd("w") -- Save function
	vim.notify("File saved successfully!", vim.log.levels.INFO)
end, map_opts)
map("n", "<leader>b", "<cmd>enew<cr>", { desc = "new buffer" })
map("n", "<Esc>", "<cmd>noh<CR>", map_opts) -- clear highlights
map("n", "<leader>x", "<cmd>bd<cr>", { desc = "close buffer" })
map("n", "<leader>X", "<cmd>%bd<cr>", { desc = "close all buffers" })
map("n", "<leader>R", '<cmd>lua require("spectre").toggle()<cr>', { desc = "search/replace" })
map("n", ",", "<cmd>Telescope cmdline<cr>", { desc = "cmdline line" })
map("x", "<leader>p", '"_dP', map_opts) -- paste without yanking the original text
map("n", "<leader>F", function() -- conform - manual formatting
	require("conform").format({ lsp_fallback = true })
end, { desc = "format buffer" })

-- }}}
-- neo-tree.nvim mappings {{{
map("n", "<leader>fr", "<cmd>Neotree right toggle<cr>", { desc = "neotree right" })
map("n", ".", "<cmd>Neotree float toggle<cr>", map_opts)
map("n", "<leader>ff", "<cmd>Neotree float toggle<cr>", { desc = "neotree float" })
-- }}}
-- nvim-cokeline
map("n", "<Tab>", "<Plug>(cokeline-focus-next)", map_opts)
map("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", map_opts)
-- Yank commands
map({ "n", "i" }, "<A-y>", "<cmd>Telescope yank_history theme=dropdown<cr>", map_opts)
-- telescope.nvim mappings {{{
map("n", "<leader>tb", "<cmd>Telescope buffers<cr>", { desc = "buffer list" })
map("n", "<leader>tf", "<cmd>Telescope file_browser<cr>", { desc = "find files" })
map("n", "<leader>to", "<cmd>Telescope oldfiles<cr>", { desc = "find files" })
map("n", "<leader>tr", "<cmd>Telescope frecency theme=ivy<cr>", { desc = "recent files" })
map("n", "<Leader>ts", "<cmd>Telescope current_buffer_fuzzy_find case_mode=smart_case<CR>", { desc = "Find in Buffer" })
-- }}}
-- trouble.nvim {{{
map("n", "<leader>dt", "<cmd>Trouble diagnostics toggle<cr>", { desc = "global diagnostics" })
map("n", "<leader>db", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "buffer diagnostics" })
map("n", "<leader>ds", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "buffer symbols" })
-- }}}
-- session mappings - persisted.nvim {{{
map("n", "<A-s>", "<cmd>Telescope persisted theme=dropdown<cr>", map_opts)
map("n", "<A-l>", "<cmd>SessionLoadLast<cr>", { desc = "load last session" })
map("n", "<leader>sS", "<cmd>Telescope persisted<cr>", { desc = "select session" })
map("n", "<leader>ss", "<cmd>SessionSave<cr>", { desc = "save current session" })
map("n", "<leader>sl", "<cmd>SessionLoadLast<cr>", { desc = "load session" })
map("n", "<leader>st", "<cmd>SessionStop<cr>", { desc = "stop current session" })
-- }}}
-- diffview.nvim mappings {{{
map("n", "<leader>dv", "<cmd>DiffviewOpen<cr>", { desc = "diffview file" })
map("n", "<leader>dh", "<cmd>DiffviewFileHistory<cr>", { desc = "diffview history" })
map("n", "<leader>df", "<cmd>DiffviewFileHistory %<cr>", { desc = "diffview file history" })
map("n", "<leader>dc", "<cmd>DiffviewClose<cr>", { desc = "diffview close" })
-- }}}
-- searchbox mappings - searchbox.nvim {{{
map(
	"n",
	"<leader>si",
	"<cmd>SearchBoxIncSearch title=' Incremental Search' exact=true<cr>",
	{ desc = "search (incremental)" }
)
map(
	"n",
	"<leader>sa",
	"<cmd>SearchBoxMatchAll title=' Search Match All' exact=true<cr>",
	{ desc = "search (match all)" }
)
map(
	"n",
	"<leader>sr",
	"<cmd>SearchBoxReplace title=' Search and Replace' exact=true confirm=menu<cr>",
	{ desc = "search and replace" }
)
-- }}}
-- git mappings {{{
map("n", "<leader>gm", "<cmd>Neogit<cr>", { desc = "git manager (workspace)" })
map("n", "<leader>gM", "<cmd>Neogit cwd=%:p:h<cr>", { desc = "git manager (buffer)" })
map("n", "<leader>gc", "<cmd>Neotree git_status bottom<cr>", { desc = "neo-tree git status" })
map("n", "<leader>gh", "<cmd>Telescope git_commits<cr>", { desc = "git commits history" })
map("n", "<leader>gb", "<cmd>Telescope git_bcommits<cr>", { desc = "git commits buffer" })
-- }}}
-- search mappings {{{
map(
	"n",
	"<leader>rw",
	'<cmd>lua require("spectre").open_visual({select_word=true})<cr>',
	{ desc = "Search current word" }
)
map(
	"n",
	"<leader>rp",
	'<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
	{ desc = "Search on current file" }
)
-- }}}

-- gitsign.nvim mapping {{{
-- require("gitsigns").setup({
-- 	on_attach = function(bufnr)
-- 		local gsmap = require("gitsigns")
--
-- 		local function gmap(mode, l, r, opts)
-- 			opts = opts or {}
-- 			opts.buffer = bufnr
-- 			vim.keymap.set(mode, l, r, opts)
-- 		end
--
-- 		-- Navigation
-- 		gmap("n", "]c", function()
-- 			if vim.wo.diff then
-- 				vim.cmd.normal({ "]c", bang = true })
-- 			else
-- 				gsmap.nav_hunk("next")
-- 			end
-- 		end)
--
-- 		gmap("n", "[c", function()
-- 			if vim.wo.diff then
-- 				vim.cmd.normal({ "[c", bang = true })
-- 			else
-- 				gsmap.nav_hunk("prev")
-- 			end
-- 		end)
--
-- 		-- Actions
-- 		gmap("n", "<leader>hs", gsmap.stage_hunk, { desc = "stage hunk" })
-- 		gmap("n", "<leader>hu", gsmap.undo_stage_hunk, { desc = "undo stage hunk" })
-- 		gmap("n", "<leader>hr", gsmap.reset_hunk, { desc = "reset hunk" })
--
-- 		gmap("v", "<leader>hs", function()
-- 			gsmap.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
-- 		end, { desc = "stage hunk" })
--
-- 		gmap("v", "<leader>hr", function()
-- 			gsmap.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
-- 		end, { desc = "reset hunk" })
--
-- 		gmap("n", "<leader>hS", gsmap.stage_buffer, { desc = "stage buffer" })
-- 		gmap("n", "<leader>hR", gsmap.reset_buffer, { desc = "reset buffer" })
-- 		gmap("n", "<leader>hp", gsmap.preview_hunk, { desc = "preview hunk" })
-- 		gmap("n", "<leader>hi", gsmap.preview_hunk_inline, { desc = "preview hunk inline" })
--
-- 		gmap("n", "<leader>hb", function()
-- 			gsmap.blame_line({ full = true })
-- 		end, { desc = "Blame line" })
--
-- 		gmap("n", "<leader>hd", gsmap.diffthis, { desc = "diff this" })
--
-- 		gmap("n", "<leader>hD", function()
-- 			gsmap.diffthis("~")
-- 		end, { desc = "Diff this colored" })
--
-- 		gmap("n", "<leader>hQ", function()
-- 			gsmap.setqflist("all")
-- 		end, { desc = "hunks list - workspace" })
-- 		gmap("n", "<leader>hq", gsmap.setqflist, { desc = "hunks list - buffer" })
--
-- 		-- Toggles
-- 		gmap("n", "<leader>tb", gsmap.toggle_current_line_blame, { desc = "toggle cur line blame" })
-- 		gmap("n", "<leader>td", gsmap.toggle_deleted, { desc = "toggle deleted" })
-- 		gmap("n", "<leader>tw", gsmap.toggle_word_diff, { desc = "toggle word diff" })
--
-- 		-- Text object
-- 		gmap({ "o", "x" }, "ih", gsmap.select_hunk, { desc = "Select hunk" })
-- 	end,
-- })
-- }}}
-- Move to the end of yanked text after yank and paste
vim.cmd("vnoremap <silent> y y`]")
vim.cmd("vnoremap <silent> p p`]")
