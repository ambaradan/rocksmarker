-- Require the color utilities module
local colors = require("utils.colors")

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

-- lualine.nvim settings {{{

require("lualine").setup({
	options = {
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = {
			{
				"mode",
				fmt = function(mode)
					return " " .. mode
				end,
				separator = { left = "" },
				right_padding = 2,
				color = { gui = "bold" },
			},
		},
		lualine_b = {
			{
				"filename",
				color = { fg = colors.get_col("String", "fg") },
			},
			{
				"branch",
				color = { fg = colors.get_col("Debug", "fg") },
			},
		},
		lualine_c = {
			{
				"diff",
				symbols = { added = " ", modified = " ", removed = " " },
			},
			"%=",
		},
		lualine_x = {
			{
				function()
					local msg = "No Active Lsp"
					local buf_ft = vim.bo[0].filetype
					local clients = vim.lsp.get_clients()
					if next(clients) == nil then
						return msg
					end
					for _, client in ipairs(clients) do
						local filetypes = client.config.filetypes
						if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
							return client.name
						end
					end
					return msg
				end,
				icon = " LSP:",
				color = { fg = colors.get_col("Comment", "fg"), gui = "bold" },
			},
		},
		lualine_y = {
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " " },
			},
			"filetype",
			"progress",
		},
		lualine_z = {
			{ "location", separator = { right = "" }, left_padding = 2 },
		},
	},
	inactive_sections = {
		lualine_a = { "filename" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
})

-- }}}

-- bufferline.nvim settings {{{

require("bufferline").setup({
	options = {
		-- Appearance settings
		mode = "buffers", -- Display mode (buffers or tabs)
		numbers = "both", -- Show buffer index and ordinal number
		close_command = "bdelete! %d", -- Command to close a buffer
		right_mouse_command = "bdelete! %d", -- Right-click buffer action
		left_mouse_command = "buffer %d", -- Left-click buffer action
		indicator = {
			icon = "▎", -- Buffer indicator style
			style = "icon",
		},

		-- Styling
		buffer_close_icon = "󰅖",
		modified_icon = "● ",
		close_icon = " ",
		left_trunc_marker = " ",
		right_trunc_marker = " ",

		-- Diagnostics integration
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		diagnostics_indicator = function(count, level)
			local icon = level:match("error") and " " or " "
			return icon .. count
		end,

		-- Custom coloring
		highlights = {
			buffer_selected = {
				bold = true,
				italic = true,
			},
			diagnostic_selected = {
				bold = true,
			},
		},

		-- Separator styles
		separator_style = "slant", -- Options: "slant", "thick", "thin", "padded"
		always_show_bufferline = true,
		show_buffer_icons = true,
		show_buffer_close_icons = true,
		show_close_icon = true,

		-- Sorting
		sort_by = "insert_after_current",

		-- Offsets (e.g., for file tree)
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				highlight = "Directory",
				separator = true,
			},
		},
	},
})

-- }}}

-- fidget.nvim settings - messages display {{{
require("fidget").setup({
	progress = {
		ignore = {
			["cmp"] = true, -- for the cmp plugin
			["lspinfo"] = true, -- for the lspinfo buffer
			["qf"] = true, -- for the quickfix window
			["vim"] = true, -- for Vim buffers
		},
	},
	notification = {
		override_vim_notify = true,
		window = {
			normal_hl = "Keyword",
		},
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
	on_attach = function(bufnr)
		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end
		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end)
		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)
		-- Actions
		map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "stage hunk" })
		map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "reset hunk" })
		map("v", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "stage hunk" })
		map("v", "<leader>hr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "reset hunk" })
		map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "stage buffer" })
		map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "reset buffer" })
		map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "preview hunk" })
		map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "preview hunk inline" })
		map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "blame line" })
		map("n", "<leader>hd", gitsigns.diffthis, { desc = "diff this" })
		map("n", "<leader>hD", function()
			gitsigns.diffthis("~")
		end, { desc = "Diff this colored" })
		map("n", "<leader>hQ", function()
			gitsigns.setqflist("all")
		end, { desc = "hunks list - buffer" })
		map("n", "<leader>hq", gitsigns.setqflist, { desc = "hunks list - buffer" })
		-- Toggles
		map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "toggle cur line blame" })
		map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "toggle deleted" })
		map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "toggle word diff" })
		-- Text object
		map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select hunk" })
	end,
})
-- }}}

-- which-key.nvim settings {{{
require("which-key").setup({
	preset = "modern",
})
-- }}}
