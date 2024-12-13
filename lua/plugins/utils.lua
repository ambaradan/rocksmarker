-- persisted.nvim settings
require("persisted").setup({
	autoload = false,
})
-- enable Telescope support
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
	live_update = false, -- auto execute search again when you write to any file
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
-- enable Telescope support
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

-- nvim-autopairs.nvim settings
require("nvim-autopairs").setup({
	disable_filetype = { "TelescopePrompt", "vim" },
})
-- nvim-highlight-colors.nvim settings
require("nvim-highlight-colors").setup({
	render = "virtual",
})
