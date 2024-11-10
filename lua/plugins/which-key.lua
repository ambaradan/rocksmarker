require("which-key").setup({
	preset = "helix",
})

local wk = require("which-key")
wk.add({
	{ "<leader>n", group = "neo-tree" },
	{ "<leader>nr", "<cmd>Neotree right toggle<cr>", desc = "Neotree right" },
	{ "<F12>", "<cmd>Neotree float toggle<cr>", desc = "Neotree float" },
	{ "<leader>nf", "<cmd>Neotree float toggle<cr>", desc = "Neotree float" },
	{ "<leader>nc", "<cmd>Neotree git_status bottom<cr>", desc = "Git Status Float", mode = "n" },
	{ "<leader>d", group = "diagnostics" },
	{ "<leader>dt", "<cmd>Trouble diagnostics toggle<cr>", desc = "Global Diagnostics" },
	{ "<leader>db", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
	{ "<leader>ds", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
	-- session mappings - persisted.nvim
	{ "<leader>s", group = "sessions" }, -- group
	{ "<A-s>", "<cmd>Telescope persisted<cr>", desc = "Select session" },
	{ "<leader>sS", "<cmd>Telescope persisted<cr>", desc = "Select session" },
	{ "<leader>ss", "<cmd>SessionSave<cr>", desc = "Save current session", mode = "n" },
	{ "<leader>sl", "<cmd>SessionLoad<cr>", desc = "Load session", mode = "n" },
	{ "<leader>st", "<cmd>SessionStop<cr>", desc = "Stop current session", mode = "n" },
	{ "<A-l>", "<cmd>SessionLoadLast<cr>", desc = "Load last session", mode = "n" },

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
