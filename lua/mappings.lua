require("which-key").setup({
	preset = "helix",
})

local wk = require("which-key")
wk.add({
	-- main commands
	{
		{ "<leader>q", "<cmd>q<cr>", desc = "quit editor" },
		{ "<C-s>", "<cmd>w<cr>", desc = "save buffer", mode = { "i", "n" } },
		{ "<leader>b", "<cmd>enew<cr>", desc = "new buffer" },
		{ "<Esc>", "<cmd>noh<CR>", desc = "clear highlights" },
		{ "<leader>x", "<cmd>bd<cr>", desc = "close buffer" },
		{ "<leader>X", "<cmd>%bd<cr>", desc = "close all buffers" },
		{ "<leader>R", '<cmd>lua require("spectre").toggle()<cr>', desc = "search/replace" },
		{ ",", "<cmd>Telescope cmdline<cr>", desc = "cmdline line", mode = "n" },
	},
	-- neo-tree.nvim mappings
	{ "<leader>f", group = "file manager" },
	{ "<leader>fr", "<cmd>Neotree right toggle<cr>", desc = "neotree right" },
	{ ".", "<cmd>Neotree float toggle<cr>", desc = "neotree float" },
	{ "<leader>ff", "<cmd>Neotree float toggle<cr>", desc = "neotree float" },
	-- nvim-cokeline
	{ "<Tab>", "<Plug>(cokeline-focus-next)", desc = "next buffer" },
	{ "<S-Tab>", "<Plug>(cokeline-focus-prev)", desc = "prev buffer" },
	-- Yank commands
	{ "<A-y>", "<cmd>Telescope yank_history theme=dropdown<cr>", desc = "Yank History", mode = { "n", "i" } },
	-- telescope.nvim mappings
	{ "<leader>t", group = "telescope" },
	{ "<leader>tb", "<cmd>Telescope buffers<cr>", desc = "buffer list", mode = "n" },
	{ "<leader>tc", "<cmd>Telescope command_history<cr>", desc = "command history", mode = "n" },
	{ "<leader>tf", "<cmd>Telescope file_browser<cr>", desc = "find files", mode = "n" },
	{ "<leader>to", "<cmd>Telescope oldfiles<cr>", desc = "find files", mode = "n" },
	{ "<leader>tr", "<cmd>Telescope frecency theme=ivy<cr>", desc = "recent files", mode = "n" },
	{ "<leader>tu", "<cmd>Telescope undo theme=ivy<cr>", desc = "undo changes", mode = "n" },
	-- trouble.nvim
	{ "<leader>d", group = "diagnostics" },
	{ "<leader>dt", "<cmd>Trouble diagnostics toggle<cr>", desc = "global diagnostics" },
	{ "<leader>db", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "buffer diagnostics" },
	{ "<leader>ds", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "buffer symbols" },
	-- diffview.nvim mappings
	{ "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "diffview file" },
	{ "<leader>dh", "<cmd>DiffviewFileHistory<cr>", desc = "diffview history" },
	{ "<leader>df", "<cmd>DiffviewFileHistory %<cr>", desc = "diffview file history" },
	{ "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "diffview close" },
	-- session mappings - persisted.nvim
	{ "<leader>s", group = "sessions" }, -- group
	{ "<A-s>", "<cmd>Telescope persisted theme=dropdown<cr>", desc = "select session" },
	{ "<leader>sS", "<cmd>Telescope persisted<cr>", desc = "select session" },
	{ "<leader>ss", "<cmd>SessionSave<cr>", desc = "save current session", mode = "n" },
	{ "<leader>sl", "<cmd>SessionLoadLast<cr>", desc = "load session", mode = "n" },
	{ "<leader>st", "<cmd>SessionStop<cr>", desc = "stop current session", mode = "n" },
	{ "<A-l>", "<cmd>SessionLoadLast<cr>", desc = "load last session", mode = "n" },
	-- searchbox mappings - searchbox.nvim
	{
		"<leader>si",
		"<cmd>SearchBoxIncSearch title=IncSearch exact=true<cr>",
		desc = "search (incremental)",
		mode = "n",
	},
	{
		"<leader>sa",
		"<cmd>SearchBoxMatchAll title=MatchAll exact=true clear_matches=false<cr>",
		desc = "search (match all)",
		mode = "n",
	},
	{
		"<leader>sr",
		"<cmd>SearchBoxReplace title=SearchReplace exact=true confirm=menu<cr>",
		desc = "search and replace",
		mode = "n",
	},
	-- git mappings
	{ "<leader>g", group = "git" },
	{ "<leader>gc", "<cmd>Neotree git_status bottom<cr>", desc = "neo-tree git status", mode = "n" },
	{ "<leader>gh", "<cmd>Telescope git_commits<cr>", desc = "git commits history", mode = "n" },
	{ "<leader>gb", "<cmd>Telescope git_bcommits<cr>", desc = "git commits buffer", mode = "n" },
	{ "<leader>gm", "<cmd>Neogit<cr>", desc = "git manager (workspace)", mode = "n" },
	{ "<leader>gM", "<cmd>Neogit cwd=%:p:h<cr>", desc = "git manager (current)", mode = "n" },
	-- search mappings
	{ "<leader>r", group = "search" },
	{ "<leader>rw", '<cmd>lua require("spectre").open_visual({select_word=true})<cr>', desc = "Search current word" },
	{
		"<leader>rp",
		'<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
		desc = "Search on current file",
	},

	-- others mappings
	{
		"<leader>F",
		function()
			require("conform").format({ lsp_fallback = true })
		end,
		desc = "format buffer",
		mode = "n",
	},

	-- gitsign.nvim mapping
	require("gitsigns").setup({
		on_attach = function(bufnr)
			local gsmap = require("gitsigns")

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gsmap.nav_hunk("next")
				end
			end)

			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gsmap.nav_hunk("prev")
				end
			end)

			-- Actions
			map("n", "<leader>hs", gsmap.stage_hunk, { desc = "stage hunk" })
			map("n", "<leader>hu", gsmap.undo_stage_hunk, { desc = "undo stage hunk" })
			map("n", "<leader>hr", gsmap.reset_hunk, { desc = "reset hunk" })

			map("v", "<leader>hs", function()
				gsmap.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "stage hunk" })

			map("v", "<leader>hr", function()
				gsmap.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "reset hunk" })

			map("n", "<leader>hS", gsmap.stage_buffer, { desc = "stage buffer" })
			map("n", "<leader>hR", gsmap.reset_buffer, { desc = "reset buffer" })
			map("n", "<leader>hp", gsmap.preview_hunk, { desc = "preview hunk" })
			map("n", "<leader>hi", gsmap.preview_hunk_inline, { desc = "preview hunk inline" })

			map("n", "<leader>hb", function()
				gsmap.blame_line({ full = true })
			end, { desc = "Blame line" })

			map("n", "<leader>hd", gsmap.diffthis, { desc = "diff this" })

			map("n", "<leader>hD", function()
				gsmap.diffthis("~")
			end, { desc = "Diff this colored" })

			map("n", "<leader>hQ", function()
				gsmap.setqflist("all")
			end, { desc = "hunks list - workspace" })
			map("n", "<leader>hq", gsmap.setqflist, { desc = "hunks list - buffer" })

			-- Toggles
			map("n", "<leader>tb", gsmap.toggle_current_line_blame, { desc = "toggle cur line blame" })
			map("n", "<leader>td", gsmap.toggle_deleted, { desc = "toggle deleted" })
			map("n", "<leader>tw", gsmap.toggle_word_diff, { desc = "toggle word diff" })

			-- Text object
			map({ "o", "x" }, "ih", gsmap.select_hunk, { desc = "Select hunk" })
		end,
	}),
})

-- Move to the end of yanked text after yank and paste
vim.cmd("vnoremap <silent> y y`]")
vim.cmd("vnoremap <silent> p p`]")
