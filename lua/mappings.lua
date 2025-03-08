-- Rocksmarker mappings
local remap = function(mode, lhs, rhs, opts)
	pcall(vim.keymap.del, mode, lhs)
	return vim.keymap.set(mode, lhs, rhs, opts)
end

-- local map = vim.keymap.set

local make_opt = function(desc)
	return {
		silent = true,
		noremap = true,
		desc = desc,
	}
end

-- Buffer mappings {{{
remap({ "i", "n" }, "<C-s>", "<cmd>w<cr>", make_opt(" Save buffer"))
remap("n", "<leader>s", function()
	vim.cmd("w") -- Save function
	vim.notify("File saved successfully!", vim.log.levels.INFO)
end, make_opt(" Save with message"))
remap("n", "<leader>b", "<cmd>enew<cr>", make_opt("new buffer"))
remap("n", "<leader>x", "<cmd>bd<cr>", make_opt("close buffer"))
remap("n", "<leader>X", "<cmd>%bd<cr>", make_opt("close all buffers"))
-- }}}
-- Editor mappings {{{
remap("n", "<leader>q", "<cmd>q<cr>", make_opt("quit editor"))
remap("n", "<Esc>", "<cmd>noh<CR>", make_opt("clear highlights"))
remap("n", ",", "<cmd>Telescope cmdline<cr>", make_opt("cmdline line"))
-- conform - manual formatting
remap("n", "<leader>F", function()
	require("conform").format({ lsp_fallback = true })
end, make_opt("format buffer"))
-- }}}
--
--
-- neo-tree.nvim mappings {{{
remap("n", "<leader>fr", "<cmd>Neotree right toggle<cr>", make_opt("neotree right"))
remap("n", ".", "<cmd>Neotree float toggle<cr>", make_opt("neotree right"))
remap("n", "<leader>ff", "<cmd>Neotree float toggle<cr>", make_opt("neotree float"))
-- }}}
-- nvim-cokeline
remap("n", "<Tab>", "<Plug>(cokeline-focus-next)", make_opt("next buffer"))
remap("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", make_opt("previous buffer"))
-- Yank commands
remap({ "n", "i" }, "<A-y>", "<cmd>Telescope yank_history theme=dropdown<cr>", make_opt("yank history"))
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
-- -- }}}
-- -- trouble.nvim {{{
-- map("n", "<leader>dt", "<cmd>Trouble diagnostics toggle<cr>", { desc = "global diagnostics" })
-- map("n", "<leader>db", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "buffer diagnostics" })
-- map("n", "<leader>ds", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "buffer symbols" })
-- -- }}}
-- -- session mappings - persisted.nvim {{{
remap("n", "<A-s>", "<cmd>Telescope persisted theme=dropdown<cr>", make_opt("select session"))
remap("n", "<A-l>", "<cmd>SessionLoadLast<cr>", make_opt("load last session"))
remap("n", "<leader>sS", "<cmd>Telescope persisted<cr>", make_opt("select session"))
remap("n", "<leader>ss", "<cmd>SessionSave<cr>", make_opt("save current session"))
remap("n", "<leader>sl", "<cmd>SessionLoadLast<cr>", make_opt("load session"))
remap("n", "<leader>st", "<cmd>SessionStop<cr>", make_opt("stop current session"))
-- -- }}}

-- map("n", "<leader>R", '<cmd>lua require("spectre").toggle()<cr>', { desc = "search/replace" })
-- map("x", "<leader>p", '"_dP', map_opts) -- paste without yanking the original text

-- -- diffview.nvim mappings {{{
-- map("n", "<leader>dv", "<cmd>DiffviewOpen<cr>", { desc = "diffview file" })
-- map("n", "<leader>dh", "<cmd>DiffviewFileHistory<cr>", { desc = "diffview history" })
-- map("n", "<leader>df", "<cmd>DiffviewFileHistory %<cr>", { desc = "diffview file history" })
-- map("n", "<leader>dc", "<cmd>DiffviewClose<cr>", { desc = "diffview close" })
-- -- }}}
-- -- searchbox mappings - searchbox.nvim {{{
-- map(
-- 	"n",
-- 	"<leader>si",
-- 	"<cmd>SearchBoxIncSearch title=' Incremental Search' exact=true<cr>",
-- 	{ desc = "search (incremental)" }
-- )
-- map(
-- 	"n",
-- 	"<leader>sa",
-- 	"<cmd>SearchBoxMatchAll title=' Search Match All' exact=true<cr>",
-- 	{ desc = "search (match all)" }
-- )
-- map(
-- 	"n",
-- 	"<leader>sr",
-- 	"<cmd>SearchBoxReplace title=' Search and Replace' exact=true confirm=menu<cr>",
-- 	{ desc = "search and replace" }
-- )
-- -- }}}
-- -- git mappings {{{
-- map("n", "<leader>gm", "<cmd>Neogit<cr>", { desc = "git manager (workspace)" })
-- map("n", "<leader>gM", "<cmd>Neogit cwd=%:p:h<cr>", { desc = "git manager (buffer)" })
-- map("n", "<leader>gc", "<cmd>Neotree git_status bottom<cr>", { desc = "neo-tree git status" })
-- map("n", "<leader>gh", "<cmd>Telescope git_commits<cr>", { desc = "git commits history" })
-- map("n", "<leader>gb", "<cmd>Telescope git_bcommits<cr>", { desc = "git commits buffer" })
-- -- }}}
-- -- search mappings {{{
-- map(
-- 	"n",
-- 	"<leader>rw",
-- 	'<cmd>lua require("spectre").open_visual({select_word=true})<cr>',
-- 	{ desc = "Search current word" }
-- )
-- map(
-- 	"n",
-- 	"<leader>rp",
-- 	'<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
-- 	{ desc = "Search on current file" }
-- )
-- -- }}}
--
-- vim.cmd("vnoremap <silent> y y`]")
-- vim.cmd("vnoremap <silent> p p`]")
