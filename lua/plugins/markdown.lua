-- markview.nvim settings {{{
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
-- }}}

-- markdown.nvim settings {{{
require("markdown").setup({

	on_attach = function(bufnr)
		local function toggle(key)
			return "<Esc>gv<Cmd>lua require'markdown.inline'" .. ".toggle_emphasis_visual'" .. key .. "'<CR>"
		end
		-- mapping for INSERT mode (bold, italic, inline, highlight code)
		vim.keymap.set("x", "<C-b>", toggle("b"), { buffer = bufnr })
		vim.keymap.set("x", "<C-i>", toggle("i"), { buffer = bufnr })
		vim.keymap.set("x", "<C-c>", toggle("c"), { buffer = bufnr })
		vim.keymap.set("x", "<C-s>", toggle("s"), { buffer = bufnr })
	end,
})
-- }}}

-- markdown-table-mode.nvim settings {{{
require("markdown-table-mode").setup({
	filetype = {
		"*.md",
	},
	options = {
		insert = true, -- when typeing "|"
		insert_leave = true, -- when leaveing insert
	},
})
-- }}}

-- zen-mode.nvim settings {{{
require("zen-mode").setup({
	window = {
		width = 0.85,
		options = {
			number = false,
			list = true,
			relativenumber = false,
		},
	},
	plugins = {
		options = {
			laststatus = 0,
		},
	},
})
-- }}}
