require("telescope").setup({
	defaults = {
		layout_strategy = "horizontal",
		layout_config = {
			prompt_position = "bottom",
			horizontal = {
				height = 0.85,
			},
		},
	},
	pickers = {
		buffers = {
			sort_lastused = true,
			sort_mru = true,
			previewer = false,
			hidden = true,
			theme = "ivy",
		},
		command_history = { theme = "ivy" },
		git_status = { theme = "ivy" },
		git_commits = { theme = "ivy" },
		oldfiles = { previewer = false, theme = "ivy" },
	},
	extensions = {
		file_browser = {
			theme = "ivy",
			hide_parent_dir = true,
			-- disables netrw and use telescope-file-browser in its place
			hijack_netrw = true,
			mappings = {
				["i"] = {
					-- your custom insert mode mappings
				},
				["n"] = {
					-- your custom normal mode mappings
				},
			},
		},
		frecency = {
			show_scores = true,
		},
	},
})

require("telescope").load_extension("file_browser")

require("telescope").load_extension("cmdline")

require("telescope").load_extension("frecency")

local wk = require("which-key")
wk.add({
	{ "<leader>t", group = "file" }, -- group
	{
		"<leader>tf",
		function()
			require("telescope.builtin").find_files()
		end,
		desc = "find files",
		mode = "n",
	},
	{
		"<leader>to",
		function()
			require("telescope.builtin").oldfiles()
		end,
		desc = "recent files",
		mode = "n",
	},
	{
		"<leader>tb",
		function()
			require("telescope.builtin").buffers()
		end,
		desc = "open buffers",
		mode = "n",
	},
	{
		"<leader>th",
		function()
			require("telescope.builtin").help()
		end,
		desc = "search help",
		mode = "n",
	},
	{
		"<leader>*",
		function()
			require("telescope.builtin").grep_string()
		end,
		desc = "search under cursor",
	},
})
