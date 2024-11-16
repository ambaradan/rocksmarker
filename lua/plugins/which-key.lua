require("which-key").setup({
	preset = "helix",
	-- icons = {
	-- 	color = "yellow",
	-- },
})

local wk = require("which-key")
wk.add({
	{ "<leader>f", group = "file manager" },
	{ "<leader>fr", "<cmd>Neotree right toggle<cr>", desc = "neotree right" },
	{ "<F12>", "<cmd>Neotree float toggle<cr>", desc = "neotree float" },
	{ "<leader>ff", "<cmd>Neotree float toggle<cr>", desc = "neotree float" },
	-- nvim-cokeline
	{ "<Tab>", "<Plug>(cokeline-focus-next)", desc = "next buffer" },
	{ "<S-Tab>", "<Plug>(cokeline-focus-prev)", desc = "prev buffer" },
	-- telescope.nvim mappings
	{ "<leader>t", group = "telescope" },
	{ "<leader>tb", "<cmd>Telescope buffers<cr>", desc = "buffer list", mode = "n" },
	{ "<leader>tc", "<cmd>Telescope command_history<cr>", desc = "command history", mode = "n" },
	{ "<leader>tf", "<cmd>Telescope file_browser<cr>", desc = "find files", mode = "n" },
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
	{ "<A-s>", "<cmd>Telescope persisted theme=ivy<cr>", desc = "select session" },
	{ "<leader>sS", "<cmd>Telescope persisted<cr>", desc = "select session" },
	{ "<leader>ss", "<cmd>SessionSave<cr>", desc = "save current session", mode = "n" },
	{ "<leader>sl", "<cmd>SessionLoad<cr>", desc = "load session", mode = "n" },
	{ "<leader>st", "<cmd>SessionStop<cr>", desc = "stop current session", mode = "n" },
	{ "<A-l>", "<cmd>SessionLoadLast<cr>", desc = "load last session", mode = "n" },
	-- git mappings
	{ "<leader>g", group = "git" },
	{ "<leader>gc", "<cmd>Neotree git_status bottom<cr>", desc = "neo-tree git status", mode = "n" },
	{ "<leader>gb", "<cmd>Telescope git_commits<cr>", desc = "git commits history", mode = "n" },
	{ "<leader>gb", "<cmd>Telescope git_bcommits<cr>", desc = "git commits buffer", mode = "n" },
	{ "<leader>gg", "<cmd>Neogit<cr>", desc = "git manager", mode = "n" },
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
	{
		{ "<leader>q", "<cmd>q<cr>", desc = "Close editor" },
		{ "<C-s>", "<cmd>w<cr>", desc = "Save buffer", mode = { "i", "n" } },
		{ "<leader>N", "<cmd>enew<cr>", desc = "New buffer" },
		{ "<leader>w", "<cmd>w<cr>", desc = "Save buffer" },
		{ "<leader>x", "<cmd>bd<cr>", desc = "Close buffer" },
		{ "<leader>X", "<cmd>%bd<cr>", desc = "Close all buffers" },
		{ "<leader>R", '<cmd>lua require("spectre").toggle()<cr>', desc = "Toggle Spectre" },
		{ ",", "<cmd>Telescope cmdline<cr>", desc = "Command line", mode = "n" },
		{ "<leader>c", "<cmd>Telescope cmdline<cr>", desc = "Command line" },
	},
})
