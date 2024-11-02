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

local wk = require("which-key")
wk.add({
	-- Yank commands
	{ "<A-y>", "<cmd>Telescope yank_history<cr>", desc = "Yank History", mode = { "n", "i" } },
})
