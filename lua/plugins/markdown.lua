-- lua/plugins/markdown.lua
-- Import the debug utilities
local debug_utils = require("utils.debug")

-- mkdocs-material settings {{{

require("mkdocs_material").setup({})

-- }}}

-- render-markdown.nvim settings {{{

-- Log the start of render-markdown configuration
debug_utils.log_debug("Configuring render-markdown.nvim...")

local render_ok, render_markdown = pcall(require, "render-markdown")
if not render_ok then
	debug_utils.log_debug("Failed to load render-markdown: " .. render_markdown)
else
	render_markdown.setup({
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
	debug_utils.log_debug("Successfully configured render-markdown.nvim")
end
-- }}}

-- markdown.nvim settings {{{

-- Log the start of markdown.nvim configuration
debug_utils.log_debug("Configuring markdown.nvim...")

local markdown_ok, markdown = pcall(require, "markdown")
if not markdown_ok then
	debug_utils.log_debug("Failed to load markdown.nvim: " .. markdown)
else
	markdown.setup({
		on_attach = function(bufnr)
			-- Helper function to toggle markdown emphasis
			local function toggle(key)
				return "<Esc>gv<Cmd>lua require'markdown.inline'.toggle_emphasis_visual'" .. key .. "'<CR>"
			end
			-- Keymaps for INSERT mode (bold, italic, inline code, strikethrough)
			vim.keymap.set("x", "<C-b>", toggle("b"), { buffer = bufnr })
			vim.keymap.set("x", "<C-i>", toggle("i"), { buffer = bufnr })
			vim.keymap.set("x", "<C-`>", toggle("c"), { buffer = bufnr })
			vim.keymap.set("x", "<C-s>", toggle("s"), { buffer = bufnr })
		end,
	})
	debug_utils.log_debug("Successfully configured markdown.nvim")
end
-- }}}

-- markdown-table-mode.nvim settings {{{

-- Log the start of markdown-table-mode configuration
debug_utils.log_debug("Configuring markdown-table-mode.nvim...")

local table_mode_ok, table_mode = pcall(require, "markdown-table-mode")
if not table_mode_ok then
	debug_utils.log_debug("Failed to load markdown-table-mode: " .. table_mode)
else
	table_mode.setup({
		filetype = {
			"*.md",
		},
		options = {
			insert = true, -- when typing "|"
			insert_leave = true, -- when leaving insert mode
		},
	})
	debug_utils.log_debug("Successfully configured markdown-table-mode.nvim")
end
-- }}}

-- zen-mode.nvim settings {{{

-- Log the start of zen-mode configuration
debug_utils.log_debug("Configuring zen-mode.nvim...")

local zen_mode_ok, zen_mode = pcall(require, "zen-mode")
if not zen_mode_ok then
	debug_utils.log_debug("Failed to load zen-mode: " .. zen_mode)
else
	zen_mode.setup({
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
	debug_utils.log_debug("Successfully configured zen-mode.nvim")
end
-- }-- lua/plugins/markdown.lua}
