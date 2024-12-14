-- feline settings - status line {{{
local line_ok, feline = pcall(require, "feline")
if not line_ok then
	return
end

local bamboo = {
	fg = "#c7dab9",
	bg = "#2f312c",
	bg3 = "#3a3d37",
	light_grey = "#838781",
	green = "#8fb573",
	yellow = "#ffccb2",
	purple = "#aaaaff",
	orange = "#ff9966",
	light_yellow = "#e2c792",
	coral = "#f08080",
	dark_blue = "#758094",

	dark_coral = "#893f45",
}

local vi_mode_colors = {
	NORMAL = "green",
	OP = "green",
	INSERT = "yellow",
	VISUAL = "purple",
	LINES = "orange",
	BLOCK = "dark_coral",
	REPLACE = "coral",
	COMMAND = "dark_blue",
}

local c = {
	vim_mode = {
		provider = {
			name = "vi_mode",
			opts = {
				show_mode_name = true,
				padding = "center",
			},
		},
		hl = function()
			return {
				fg = require("feline.providers.vi_mode").get_mode_color(),
				bg = "bg3",
				style = "bold",
				name = "NeovimModeHLColor",
			}
		end,
		left_sep = "block",
		right_sep = "right_filled",
	},
	gitBranch = {
		provider = "git_branch",
		hl = {
			fg = "light_yellow",
			style = "bold",
		},
		left_sep = "block",
		right_sep = "block",
	},
	gitDiffAdded = {
		provider = "git_diff_added",
		hl = {
			fg = "green",
		},
	},
	gitDiffRemoved = {
		provider = "git_diff_removed",
		hl = {
			fg = "coral",
		},
	},
	gitDiffChanged = {
		provider = "git_diff_changed",
		hl = {
			fg = "fg",
		},
	},
	separator = {
		provider = "",
	},
	fileinfo = {
		provider = {
			name = "file_info",
			opts = {
				type = "relative-short",
			},
		},
		hl = {
			fg = "light_grey",
		},
		left_sep = " ",
		right_sep = " ",
	},
	diagnostic_errors = {
		provider = "diagnostic_errors",
		hl = {
			fg = "coral",
		},
	},
	diagnostic_warnings = {
		provider = "diagnostic_warnings",
		hl = {
			fg = "yellow",
		},
	},
	diagnostic_hints = {
		provider = "diagnostic_hints",
		hl = {
			fg = "dark_blue",
		},
	},
	diagnostic_info = {
		provider = "diagnostic_info",
	},
	lsp_client_names = {
		provider = "lsp_client_names",
		hl = {
			fg = "light_grey",
			style = "bold",
		},
		left_sep = "block",
	},
	file_type = {
		provider = {
			name = "file_type",
			opts = {
				filetype_icon = true,
				case = "titlecase",
			},
		},
		hl = {
			fg = "fg",
			style = "bold",
		},
		left_sep = "block",
		right_sep = "block",
	},
	file_encoding = {
		provider = "file_encoding",
		hl = {
			fg = "orange",
			style = "italic",
		},
		left_sep = "block",
		right_sep = "block",
	},
	position = {
		provider = "position",
		hl = {
			fg = "green",
			style = "bold",
		},
		left_sep = "block",
		right_sep = "block",
	},
	line_percentage = {
		provider = "line_percentage",
		hl = {
			fg = "dark_blue",
			style = "bold",
		},
		left_sep = "block",
		right_sep = "block",
	},
	scroll_bar = {
		provider = "scroll_bar",
		hl = {
			fg = "green",
			bg = "bg3",
			style = "bold",
		},
	},
}
-- Start statusline
local left = {
	c.vim_mode,
	c.gitBranch,
	c.gitDiffAdded,
	c.gitDiffRemoved,
	c.gitDiffChanged,
	c.fileinfo,
	c.separator,
}

local middle = {
	c.lsp_client_names,
	c.diagnostic_errors,
	c.diagnostic_warnings,
	c.diagnostic_info,
	c.diagnostic_hints,
}

local right = {
	-- c.file_type,
	c.file_encoding,
	c.position,
	c.line_percentage,
	c.scroll_bar,
}

local components = {
	active = {
		left,
		middle,
		right,
	},
	inactive = {
		left,
		middle,
		right,
	},
}

feline.setup({
	components = components,
	theme = bamboo,
	vi_mode_colors = vi_mode_colors,
})
-- }}}

-- nvim-cokeline setting - bufferline {{{
local get_hex = require("cokeline/utils").get_hex

local green = vim.g.terminal_color_2
local yellow = vim.g.terminal_color_3

require("cokeline").setup({
	default_hl = {
		fg = function(buffer)
			return buffer.is_focused and get_hex("Normal", "fg") or get_hex("Conceal", "fg")
		end,
		bg = get_hex("FloatermBorder", "bg"),
	},

	components = {
		{
			text = "｜",
			fg = function(buffer)
				return buffer.is_modified and yellow or green
			end,
		},
		{
			text = function(buffer)
				return buffer.devicon.icon .. " "
			end,
			fg = function(buffer)
				return buffer.devicon.color
			end,
		},
		{
			text = function(buffer)
				return buffer.index .. ": "
			end,
		},
		{
			text = function(buffer)
				return buffer.unique_prefix
			end,
			fg = get_hex("Comment", "fg"),
			style = "italic",
		},
		{
			text = function(buffer)
				return buffer.filename .. " "
			end,
			style = function(buffer)
				return buffer.is_focused and "bold" or nil
			end,
		},
		{
			text = " ",
		},
		{
			text = function(buffer)
				return buffer.is_modified and "● " or " "
			end,
			fg = function(buffer)
				return buffer.is_modified and green or nil
			end,
		},
	},
})
-- }}}

-- fidget.nvim settings - messages display {{{
require("fidget").setup()
-- }}}

-- gitsign.nvim settings - git support {{{
local present, gitsigns = pcall(require, "gitsigns")

if not present then
	return
end

gitsigns.setup({
	signs = {
		add = { hl = "DiffAdd", text = "│", numhl = "GitSignsAddNr" },
		change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr" },
		delete = { hl = "DiffDelete", text = "│", numhl = "GitSignsDeleteNr" },
		topdelete = { hl = "DiffDelete", text = "│", numhl = "GitSignsDeleteNr" },
		changedelete = { hl = "DiffChangeDelete", text = "│", numhl = "GitSignsChangeNr" },
		untracked = { hl = "Comment", text = "│", numhl = "GitSignsChangeNr" },
	},
})
-- }}}
