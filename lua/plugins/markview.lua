local presets = require("markview.presets").headings

require("markview").setup({
	headings = presets.glow,
})

require("markview").setup({
	modes = { "n", "no", "c" }, -- Change these modes
	-- to what you need

	hybrid_modes = { "n" }, -- Uses this feature on
	-- normal mode
	-- headings = {
	-- 	enable = true,
	--
	-- 	--- Amount of character to shift per heading level
	-- 	---@type integer
	-- 	shift_width = 1,
	--
	-- 	-- heading_1 = {
	-- 	-- 	style = "label",
	-- 	-- 	--- Background highlight group.
	-- 	-- 	---@type string
	-- 	-- 	hl = "MarkviewHeading1",
	-- 	-- },
	-- 	heading_1 = {
	-- 		style = "label",
	-- 		align = "left",
	-- 		padding_left = " ",
	-- 		padding_right = " ",
	-- 	},
	-- 	heading_2 = {
	-- 		style = "label",
	-- 		align = "left",
	-- 		padding_left = " ",
	-- 		padding_right = " ",
	-- 	},
	-- },
	code_blocks = {
		enable = true,
		icons = "devicons",
		language_direction = "left",
		sign = false,
		sign_hl = "markdownCode",
	},
	links = {
		enable = false,
		--- Configuration for normal links
		hyperlinks = {
			enable = true,
			icon = "󰌷 ",
		},
	},
	tables = {
		enable = false,
	},
	-- This is nice to have
	callbacks = {
		on_enable = function(_, win)
			vim.wo[win].conceallevel = 2
			vim.wo[win].concealcursor = "c"
		end,
	},
})
