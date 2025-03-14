-- telescope.nvim settings {{{
local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<esc>"] = actions.close,
			},
		},
		-- layout_strategy = "horizontal",
		layout_config = {
			-- prompt_position = "bottom",
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
			theme = "dropdown",
		},
		command_history = { theme = "dropdown" },
		git_status = { theme = "ivy" },
		git_commits = { theme = "ivy" },
		oldfiles = { previewer = false, theme = "dropdown" },
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
			theme = "dropdown",
		},
		["ui-select"] = {
			theme = "dropdown",
			initial_mode = "normal",
			sorting_strategy = "ascending",
			layout_strategy = "horizontal",
			layout_config = {
				horizontal = {
					width = 0.5,
					height = 0.4,
					preview_width = 0.6,
				},
			},
		},
	},
})

-- in-built pickers
require("telescope").load_extension("file_browser")
require("telescope").load_extension("cmdline")
require("telescope").load_extension("frecency")
require("telescope").load_extension("ui-select")
-- }}}

-- persisted.nvim settings {{{
require("persisted").setup({
	autoload = false,
})
-- enable Telescope support
require("telescope").load_extension("persisted")
-- }}}

-- toggleterm.nvim settings {{{

require("toggleterm").setup({
	-- Basic configuration
	size = function(term)
		if term.direction == "horizontal" then
			return vim.o.lines * 0.4
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.4
		end
	end,
	open_mapping = [[<c-t>]],
	hide_numbers = true,
	direction = "float",
	-- Additional basic settings
	start_in_insert = true,
	close_on_exit = true,
	shell = vim.o.shell,
	-- Float Terminal Settings
	float_opts = {
		border = "curved",
		width = function()
			return math.floor(vim.o.columns * 0.5) -- % of screen width
		end,
		height = function()
			return math.floor(vim.o.lines * 0.4) -- % of screen height
		end,
		winblend = 10, -- Transparency level
		row = function()
			return 2 -- Row to the top of the screen
		end,
		col = function()
			return vim.o.columns - math.floor(vim.o.columns * 0.4) - 3
		end,
	},
	-- Highlight configuration
	highlights = {
		Normal = {
			guibg = "Normal",
		},
		NormalFloat = {
			link = "@comment",
		},
		FloatBorder = {
			link = "FloatBorder",
		},
	},
})

-- }}}

-- neo-tree.nvim settings {{{
require("neo-tree").setup({
	popup_border_style = "rounded",
	window = {
		position = "right",
		width = 50,
	},
})
-- }}}

-- neogit.nvim settings - git manager {{{
require("neogit").setup({
	kind = "tab",
	disable_builtin_notifications = true,
	graph_style = "unicode",
	integrations = {
		telescope = true,
		diffview = true,
	},
	status = {
		-- show_head_commit_hash = true,
		recent_commit_count = 20,
	},
	commit_view = {
		kind = "floating",
		verify_commit = vim.fn.executable("gpg") == 1,
	},
})
-- }}}

-- spectre.nvim settings - search and replace plugin {{{
require("spectre").setup({
	live_update = false, -- auto execute search again when you write to any file
})
-- }}}

-- yanky.nvim settings {{{
require("yanky").setup({
	highlight = {
		on_put = true,
		on_yank = true,
	},
	ring = {
		history_length = 200,
		storage = "shada",
		sync_with_numbered_registers = true,
		cancel_event = "update",
		ignore_registers = { "_" },
		update_register_on_cycle = false,
	},
	system_clipboard = {
		sync_with_ring = true,
	},
})
-- enable Telescope support
require("telescope").load_extension("yank_history")
-- }}}

-- indent-blankline.nvim settings {{{
require("ibl").setup({
	indent = { highlight = "IblIndent", char = "│" },
	exclude = {
		filetypes = {
			"help",
			"terminal",
			"dashboard",
			"packer",
			"TelescopePrompt",
			"TelescopeResults",
			"",
		},
		buftypes = { "terminal", "nofile" },
	},
	scope = { enabled = false },
})
-- }}}

-- nvim-autopairs.nvim settings {{{
require("nvim-autopairs").setup({
	disable_filetype = { "TelescopePrompt", "vim" },
})
-- }}}

-- nvim-highlight-colors.nvim settings {{{
require("nvim-highlight-colors").setup({
	render = "virtual",
})
-- }}}
