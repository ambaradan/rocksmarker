-- theme 'bamboo' settings {{{
require("bamboo").setup({
	-- Main options --
	-- NOTE: to use the light theme, set `vim.o.background = 'light'`
	style = "vulgaris",
	-- colors = {
	-- },
	highlights = {
		["FloatBorder"] = { fg = "$grey" },
		["IblIndent"] = { fg = "$bg1" },
		["htmlH1"] = { fg = "$bg_blue" },
		["htmlH2"] = { fg = "$green" },
		["htmlH3"] = { fg = "$yellow" },
		["htmlH4"] = { fg = "$purple" },
		["htmlH5"] = { fg = "$coral" },
		["htmlH6"] = { fg = "$red" },
		["markdownListMarker"] = { fg = "$orange" },
		["MarkviewHeading1"] = { fg = "$bg_blue", fmt = "underline" },
		["MarkviewHeading2"] = { fg = "$green", fmt = "underline" },
		["MarkviewHeading3"] = { fg = "$yellow", fmt = "underline" },
		["MarkviewHeading4"] = { fg = "$purple", fmt = "underline" },
		["MarkviewHeading5"] = { fg = "$coral", fmt = "underline" },
		["MarkviewHeading6"] = { fg = "$red", fmt = "underline" },
		["MarkviewInlineCode"] = { bg = "$yellow" },
		["markdownUrl"] = { fg = "$purple", fmt = "none" },
		["markdownCode"] = { fg = "$purple" },
		["markdownCodeBlock"] = { fg = "$cyan" },
		["markdownCodeDelimiter"] = { fg = "$yellow", bg = "$bg0" },
		["MarkviewCode"] = { fg = "$yellow" },
		["MarkviewCodeInfo"] = { fg = "$yellow" },
		["markdownBold"] = { fg = "$orange", fmt = "bold" },
		["markdownItalic"] = { fg = "$yellow", fmt = "italic" },
		["markdownLinkText"] = { fg = "$light_blue", underline = false },
		["MarkviewListItemStar"] = { fg = "$orange" },
		["MarkviewListItemMinus"] = { fg = "$orange" },
		-- Ascidoc support
		["asciidocOneLineTitle"] = { fg = "$blue", fmt = "bold" },
		["asciidocAttributeList"] = { fg = "$green" },
		["asciidocQuotedBold"] = { fg = "$orange" },
		["asciidocQuotedEmphasized"] = { fg = "$yellow" },
		["asciidocQuotedMonospaced2"] = { fg = "$purple" },
		["asciidocListBullet"] = { fg = "$green" },
		["asciidocListingBlock"] = { fg = "$light_blue" },
		["asciidocLiteralParagraph"] = { fg = "$light_blue" },
		["asciidocTableDelimiter"] = { fg = "$green" },
		["asciidocTablePrefix"] = { fg = "$green" },
		-- Telescope
		-- Telescope
		["TelescopePreviewBorder"] = { fg = "$bg1" },
		["TelescopePreviewTitle"] = { fg = "$blue" },
		["TelescopeResultsBorder"] = { fg = "$bg1" },
		["TelescopeResultsTitle"] = { fg = "$blue" },
		["TelescopePromptBorder"] = { fg = "$bg1" },
		["TelescopePromptTitle"] = { fg = "$blue" },
		-- Whichkey
		["WhichKeyBorder"] = { fg = "$bg1" },
		["WhichKeyTitle"] = { fg = "$blue" },
		["WhichKeyDesc"] = { fg = "$fg" },
		["WhichKey"] = { fg = "$light_blue" },
		-- Neotree
		["NeoTreeFloatBorder"] = { fg = "$bg1" },
		["NeoTreeNormal"] = { bg = "$bg0" },
		["NeoTreeEndOfBuffer"] = { bg = "$bg0" },
		["NeoTreeIndentMarker"] = { fg = "$bg1" },
		["NeoTreeFloatTitle"] = { fg = "$blue" },
		["NeoTreeDirectoryIcon"] = { fg = "$yellow" },
		["NeoTreeDirectoryName"] = { fg = "$green" },
		-- Neogit
		["NeogitBranch"] = { fg = "$yellow" },
		["NeogitPopupActionKey"] = { fg = "$blue" },
		["NeogitSectionHeader"] = { fg = "$orange", fmt = "bold" },
		["NeogitDiffDelete"] = { fg = "$red", bg = "$bg1" },
		["NeogitDiffDeleteHighlight"] = { fg = "$red", bg = "$bg1" },
		["NeogitDiffAdd"] = { fg = "$green", bg = "$bg1" },
		["NeogitDiffAddHighlight"] = { fg = "$green", bg = "$bg1" },
		["NeogitChangeModified"] = { fg = "$light_blue", fmt = "bold" },
		["NeogitHunkHeaderHighlight"] = { fg = "$purple", bg = "$bg3" },
		-- gitsign
		["DiffAdd"] = { fg = "$green", bg = "none" },
		["DiffChange"] = { fg = "$blue", bg = "none" },
		["DiffDelete"] = { fg = "$red", bg = "none" },
	},
})
-- }}}

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
	COMMAND = "light_grey",
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
				name = require("feline.providers.vi_mode").get_mode_highlight_name(),
				bg = require("feline.providers.vi_mode").get_mode_color(),
				fg = "bg3",
				style = "bold",
			}
		end,
		left_sep = "block",
		right_sep = "right_rounded",
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

require("cokeline").setup({
	default_hl = {
		fg = function(buffer)
			return buffer.is_focused and get_hex("Normal", "fg") or get_hex("Conceal", "fg")
		end,
		bg = get_hex("TabLineFill", "bg"),
	},

	components = {
		{
			text = " ",
			fg = function(buffer)
				return buffer.is_modified and get_hex("WarningMsg", "fg") or nil
			end,
			style = function(buffer)
				return buffer.is_modified and "bold,underline" or "underline"
			end,
		},
		{
			text = function(buffer)
				return buffer.devicon.icon .. " "
			end,
			fg = function(buffer)
				return buffer.is_modified and get_hex("WarningMsg", "fg") or nil
			end,
			style = function(buffer)
				return buffer.is_modified and "bold,underline" or "underline"
			end,
		},
		{
			text = function(buffer)
				return buffer.index .. ": "
			end,
			fg = function(buffer)
				return buffer.is_modified and get_hex("WarningMsg", "fg") or nil
			end,
			style = function(buffer)
				return buffer.is_focused and "bold,underline" or "underline"
			end,
		},
		{
			text = function(buffer)
				return buffer.unique_prefix
			end,
			style = function(buffer)
				return buffer.is_focused and "bold,underline" or "underline"
			end,
		},
		{
			text = function(buffer)
				return buffer.filename .. " "
			end,
			fg = function(buffer)
				return buffer.is_modified and get_hex("WarningMsg", "fg") or nil
			end,
			style = function(buffer)
				return buffer.is_focused and "bold,underline" or "underline"
			end,
		},
	},
})
-- }}}

-- fidget.nvim settings - messages display {{{
require("fidget").setup({
	notification = {
		override_vim_notify = true,
	},
})
-- }}}

-- gitsign.nvim settings - git support {{{
local present, gitsigns = pcall(require, "gitsigns")

if not present then
	return
end

gitsigns.setup({
	signs = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "┃" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signs_staged = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "┃" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
})
-- }}}
