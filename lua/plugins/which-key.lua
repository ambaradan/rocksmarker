require("which-key").setup({
	preset = "helix",
})

local wk = require("which-key")
wk.add({
	{ "<leader>n", group = "files" },
	{ "<leader>nr", "<cmd>Neotree right toggle<cr>", desc = "Neotree right" },
	{ "<leader>nf", "<cmd>Neotree float toggle<cr>", desc = "Neotree float" },
	{ "<leader>nc", "<cmd>Neotree git_status bottom<cr>", desc = "Git Status Float", mode = "n" },

	{
		"<leader>fm",
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
		mode = { "n", "v" }, -- NORMAL and VISUAL mode
		{ "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
		{ "<leader>w", "<cmd>w<cr>", desc = "Write" },
		{ "<leader>x", "<cmd>bd<cr>", desc = "Close buffer" },
		{ "<leader>X", "<cmd>%bd<cr>", desc = "Close all buffers" },
		{ "<leader>ff", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
		{ "<leader>c", "<cmd>Telescope cmdline<cr>", desc = "Command line" },
	},
})

-- Aligns the table cells to the width
vim.keymap.set("v", "<leader>ta", "!pandoc -t markdown-simple_tables<cr>", { silent = true, desc = "Align md table" })
