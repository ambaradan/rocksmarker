require("which-key").setup({
	preset = "helix",
})

local wk = require("which-key")
wk.add({
	{ "<leader>n", group = "neo-tree" },
	{ "<leader>nr", "<cmd>Neotree right toggle<cr>", desc = "neotree right" },
	{ "<F12>", "<cmd>Neotree float toggle<cr>", desc = "neotree float" },
	{ "<leader>nf", "<cmd>Neotree float toggle<cr>", desc = "neotree float" },
	{ "<leader>nc", "<cmd>Neotree git_status bottom<cr>", desc = "git status float", mode = "n" },
	{ "<leader>d", group = "diagnostics" },
	-- trouble.nvim
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
	{ "<A-s>", "<cmd>Telescope persisted<cr>", desc = "select session" },
	{ "<leader>sS", "<cmd>Telescope persisted<cr>", desc = "select session" },
	{ "<leader>ss", "<cmd>SessionSave<cr>", desc = "save current session", mode = "n" },
	{ "<leader>sl", "<cmd>SessionLoad<cr>", desc = "load session", mode = "n" },
	{ "<leader>st", "<cmd>SessionStop<cr>", desc = "stop current session", mode = "n" },
	{ "<A-l>", "<cmd>SessionLoadLast<cr>", desc = "load last session", mode = "n" },

	-- others mappings
	{
		"<leader>F",
		function()
			require("conform").format({ lsp_fallback = true })
		end,
		desc = "format buffer",
		mode = "n",
	},
	{ "<leader>b", group = "buffers" },
	{
		"<leader>bl",
		expand = function()
			return require("which-key.extras").expand.buf()
		end,
		desc = "List buffers",
	},
	{ "<leader>bn", "<cmd>enew<cr>", desc = "New buffer" },
	-- { "<tab>", "<cmd>bnext<cr>", desc = "next buffer", mode = "n" },
	-- { "<S-tab>", "<cmd>bprevious<cr>", desc = "previous buffer", mode = "n" },
	{
		-- Nested mappings are allowed and can be added in any order
		-- Most attributes can be inherited or overridden on any level
		-- There's no limit to the depth of nesting
		-- mode = { "n", "v" }, -- NORMAL and VISUAL mode
		{ "<leader>q", "<cmd>q<cr>", desc = "Close editor" }, -- no need to specify mode since it's inherited
		{ "<leader>w", "<cmd>w<cr>", desc = "Save buffer" },
		{ "<leader>x", "<cmd>bd<cr>", desc = "Close buffer" },
		{ "<leader>X", "<cmd>%bd<cr>", desc = "Close all buffers" },
		{ "<leader>ff", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
		{ "<leader>c", "<cmd>Telescope cmdline<cr>", desc = "Command line" },
	},
})
