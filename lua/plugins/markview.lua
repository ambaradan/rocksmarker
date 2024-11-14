require("markview").setup({
	code_blocks = {
		enable = true,
		language_direction = "left",
		sign = false,
	},
	links = {
		enable = true,
		hyperlinks = {
			enable = false,
		},
	},
	tables = {
		enable = false,
	},
	headings = {
		enable = true,
		shift_width = 1,
		heading_1 = {
			style = "icon",
			icon = " 󰉫 ",
			sign = " ",
		},
		heading_2 = {
			style = "label",
			sign = " ",
			icon = " 󰉬 ",
			shift_char = " ",
		},
		heading_3 = {
			style = "label",
			sign = " ",
			icon = " 󰉭 ",
			shift_char = " ",
		},
		heading_4 = {
			style = "label",
			sign = " ",
			icon = " 󰉮 ",
			shift_char = " ",
		},
		heading_5 = {
			style = "label",
			sign = " ",
			icon = " 󰉯 ",
			shift_char = " ",
		},
		heading_6 = {
			style = "label",
			sign = " ",
			icon = " 󰉰 ",
			shift_char = " ",
		},
	},
})
