vim.o.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize"

require("persisted").setup({
	autoload = false,
})

require("telescope").load_extension("persisted")

local wk = require("which-key")
wk.add({
	{ "<leader>s", group = "file" }, -- group
	{ "<leader>sS", "<cmd>Telescope persisted<cr>", desc = "Select session" },
	{
		"<leader>ss",
		function()
			require("persisted").save()
		end,
		desc = "Save Current Session",
		mode = "n",
	},
	{
		"<leader>sl",
		function()
			require("persisted").load()
		end,
		desc = "Load Session",
		mode = "n",
	},
	{
		"<leader>st",
		function()
			require("persisted").stop()
		end,
		desc = "Stop Current Session",
		mode = "n",
	},
	{
		"<A-l>",
		function()
			require("persisted").load({ last = true })
		end,
		desc = "Load Last Session",
		mode = "n",
	},
	{
		"<A-s>",
		function()
			require("persisted").select()
		end,
		desc = "Load Last Session",
		mode = "n",
	},
})
