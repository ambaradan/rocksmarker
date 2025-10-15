-- This script configures various utility plugins for Neovim,
-- including telescope, persisted, toggleterm, neo-tree,
-- neogit, spectre, yanky, indent-blankline, and rainbow-delimiters.
-- It sets up these plugins for a more efficient and productive
-- editing experience.

local debug_utils = require("utils.debug")

-- telescope.nvim settings {{{
-- Log the start of Telescope setup
debug_utils.log_debug("Setting up Telescope...")

-- Load Telescope actions
local actions_ok, actions = pcall(require, "telescope.actions")
if not actions_ok then
	debug_utils.log_debug("Failed to load telescope.actions: " .. actions)
else
	debug_utils.log_debug("Successfully loaded telescope.actions")
end

-- Configure Telescope
local telescope_ok, telescope = pcall(require, "telescope")
if not telescope_ok then
	debug_utils.log_debug("Failed to load Telescope: " .. telescope)
else
	telescope.setup({
		defaults = {
			prompt_prefix = "   ",
			selection_caret = " ",
			entry_prefix = " ",
			layout_config = {
				horizontal = {
					prompt_position = "top",
					preview_width = 0.55,
				},
				width = 0.87,
				height = 0.80,
			},
		},
		mappings = {
			i = {
				["<esc>"] = actions.close,
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
				hijack_netrw = true,
				mappings = {
					["i"] = {},
					["n"] = {},
				},
			},
			frecency = {
				show_scores = true,
				theme = "dropdown",
			},
			undo = {
				theme = "ivy",
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
	debug_utils.log_debug("Successfully configured Telescope")
end

-- Load Telescope extensions
local extensions = {
	"file_browser",
	"cmdline",
	"frecency",
	"ui-select",
	"fidget",
	"undo",
}

for _, ext in ipairs(extensions) do
	debug_utils.log_debug("Loading Telescope extension: " .. ext)
	local ok, err = pcall(function()
		telescope.load_extension(ext)
	end)
	if not ok then
		debug_utils.log_debug("Failed to load Telescope extension " .. ext .. ": " .. err)
	else
		debug_utils.log_debug("Successfully loaded Telescope extension: " .. ext)
	end
end

-- }}}

-- persisted.nvim settings {{{
-- Log the start of persisted.nvim setup
debug_utils.log_debug("Setting up persisted.nvim...")

-- Configure persisted.nvim
local persisted_ok, persisted = pcall(require, "persisted")
if not persisted_ok then
	debug_utils.log_debug("Failed to load persisted.nvim: " .. persisted)
else
	persisted.setup({
		autoload = false,
	})
	debug_utils.log_debug("Successfully configured persisted.nvim")
end

-- Enable Telescope support for persisted.nvim
debug_utils.log_debug("Loading Telescope extension for persisted.nvim...")
local telescope_persisted_ok, telescope_error = pcall(function()
	require("telescope").load_extension("persisted")
end)

if not telescope_persisted_ok then
	debug_utils.log_debug("Failed to load Telescope extension for persisted.nvim: " .. telescope_error)
else
	debug_utils.log_debug("Successfully loaded Telescope extension for persisted.nvim")
end
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

local function calculate_width_percentage(percentage)
	local screen_width = vim.o.columns
	return math.floor(screen_width * (percentage / 100))
end

require("neo-tree").setup({
	-- Close Neo-tree if it is the last window in the tab
	close_if_last_window = false,

	-- File system configuration
	filesystem = {
		bind_to_cwd = true, -- Open Neo-tree at the current working directory
		follow_current_file = {
			enabled = true, -- Update the tree when switching buffers
		},
		use_libuv_file_watcher = true, -- Use libuv for file watching (better performance)
		filtered_items = {
			visible = true, -- Show hidden files (dotfiles)
			hide_dotfiles = false,
			hide_gitignored = true,
			hide_by_name = {
				-- Files or directories to hide
				".DS_Store",
				"thumbs.db",
			},
			never_show = {
				-- Files or directories that should never be shown
				".git",
			},
		},
		window = {
			mappings = {
				-- Key mappings for the file system window
				["l"] = "open",
				["h"] = "close_node",
				["<cr>"] = "open",
				["o"] = "open",
				["<esc>"] = "cancel",
			},
		},
	},

	-- Buffer explorer configuration
	buffers = {
		follow_current_file = {
			enabled = true, -- Update the tree when switching buffers
		},
		group_empty_dirs = true, -- Group empty directories together
	},

	-- Git status configuration
	git_status = {
		window = {
			position = "right", -- Position of the git status window
			mappings = {
				-- Key mappings for the git status window
				["A"] = "git_add_all",
				["gu"] = "git_unstage_file",
				["ga"] = "git_add_file",
				["gr"] = "git_revert_file",
				["gc"] = "git_commit",
				["gp"] = "git_push",
				["gg"] = "git_commit_and_push",
			},
			symbols = {
				-- Symbols for different file states
				added = "✚", -- Added files
				modified = "", -- Modified files
				deleted = "✖", -- Deleted files
				renamed = "", -- Renamed files
				untracked = "", -- Untracked files
				ignored = "", -- Ignored files
				unstaged = "", -- Unstaged changes
				staged = "", -- Staged changes
				conflict = "", -- Conflict files
			},
		},
	},
	diagnostics = {
		symbols = {
			-- Symbols for diagnostic issues
			hint = "", -- Hint diagnostics
			info = "", -- Info diagnostics
			warn = "", -- Warning diagnostics
			error = "", -- Error diagnostics
		},
	},
	-- Default component configurations
	default_component_configs = {
		indent = {
			indent_size = 2, -- Indentation size
			padding = 0, -- Extra padding
		},
		icon = {
			folder_closed = "", -- Icon for closed folders
			folder_open = "", -- Icon for open folders
			folder_empty = "", -- Icon for empty folders
			default = "", -- Default file icon
		},
		modified = {
			symbol = "[+]", -- Symbol for modified files
		},
		name = {
			trailing_slash = true, -- Add trailing slash to directory names
		},
	},

	-- Window configuration
	window = {
		position = "left", -- Position: "left", "right", "top", "bottom"
		width = calculate_width_percentage(40), -- Width of the Neo-tree window
		mappings = {
			-- Global key mappings for Neo-tree
			["<space>"] = "none",
			["l"] = "open",
			["h"] = "close_node",
			["<cr>"] = "open",
			["o"] = "open",
			["<esc>"] = "cancel",
		},
	},

	-- Filesystem filters
	filesystem_filters = {
		exclude = {
			-- Files or directories to exclude
			".git",
			"node_modules",
		},
	},

	-- Event handlers
	event_handlers = {
		{
			event = "file_opened",
			handler = function()
				-- Close Neo-tree after opening a file
				require("neo-tree.command").execute({ action = "close" })
			end,
		},
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

-- raimbow-delimiters setting {{{

require("rainbow-delimiters.setup").setup({
	strategy = {
		[""] = require("rainbow-delimiters").strategy["global"],
		vim = require("rainbow-delimiters").strategy["local"],
	},
	query = {
		[""] = "rainbow-delimiters",
		lua = "rainbow-blocks",
	},
	highlight = {
		"RainbowDelimiterRed",
		"RainbowDelimiterYellow",
		"RainbowDelimiterBlue",
		"RainbowDelimiterOrange",
		"RainbowDelimiterGreen",
		"RainbowDelimiterViolet",
		"RainbowDelimiterCyan",
	},
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
