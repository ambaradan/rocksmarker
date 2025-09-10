-- This script configures the markdown settings for Neovim,
-- including markview, markdown, markdown-table-mode, and
-- zen-mode. It sets up these plugins for a more efficient
-- and productive markdown editing experience.

-- render-markdown.nvim settings {{{
require("render-markdown").setup({
	heading = {
		sign = false,
		icons = { "⌂ ", "¶ ", "§ ", "❡ ", "⁋ ", "※ " },
		width = "block",
		border = true,
		border_virtual = true,
		left_pad = 2,
		right_pad = 4,
	},
	code = { sign = false, width = "block", left_pad = 2, right_pad = 4, min_width = 45 },
	pipe_table = { style = "normal" },
	latex = { enabled = false },
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
