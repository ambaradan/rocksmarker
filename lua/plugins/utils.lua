-- persisted.nvim settings
require("persisted").setup({
	autoload = false,
})

require("telescope").load_extension("persisted")

-- toggleterm.nvim settings
local terminal = require("toggleterm")
terminal.setup({
	on_config_done = nil,
	size = 20,
	open_mapping = [[<c-t>]],
	hide_numbers = true,
})

-- spectre.nvim settings - search and replace plugin
require("spectre").setup({
	live_update = false, -- auto execute search again when you write to any file in vim
})

-- yanky.nvim settings
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
require("telescope").load_extension("yank_history")

-- indent-blankline.nvim settings
local present, ibl = pcall(require, "ibl")

if not present then
	return
end

ibl.setup({
	indent = { char = "│" },
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

-- mini.pairs setting
require("mini.pairs").setup()

-- nvim-highlight-colors.nvim settings
require("nvim-highlight-colors").setup({
	render = "virtual",
})
