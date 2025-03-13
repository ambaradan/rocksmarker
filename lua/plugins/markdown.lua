-- markview.nvim settings {{{
local presets = require("markview.presets").headings
local table_presets = require("markview.presets").tables

require("markview").setup({
	markdown = {
		headings = presets.glow,
		tables = table_presets.rounded,
	},
})

require("markview").setup({
	markdown = {
		code_blocks = {
			style = "block",
			enable = true,
			sign = false,
		},
		-- tables = {
		-- 	enable = false,
		-- },
		headings = {
			heading_1 = {
				icon = " 󰉫 ",
				sign = " ",
			},
			heading_2 = {
				sign = " ",
				icon = " 󰉬 ",
				shift_char = " ",
			},
			heading_3 = {
				sign = " ",
				icon = " 󰉭 ",
				shift_char = " ",
			},
			heading_4 = {
				sign = " ",
				icon = " 󰉮 ",
				shift_char = " ",
			},
			heading_5 = {
				sign = " ",
				icon = " 󰉯 ",
				shift_char = " ",
			},
			heading_6 = {
				sign = " ",
				icon = " 󰉰 ",
				shift_char = " ",
			},
		},
	},
	markdown_inline = {
		enable = true,
		hyperlinks = {
			enable = true,
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
		vim.keymap.set("x", "<C-`>", toggle("c"), { buffer = bufnr })
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
