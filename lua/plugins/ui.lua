-- This script configures the user interface for Neovim,
-- including colors, lualine, bufferline, and other visual
-- elements. It includes safe loading and debug logging.

local debug_utils = require("utils.debug")

-- Require the color utilities module
debug_utils.log_debug("Loading min-theme colors...")
local colors
local min_colors_ok, min_theme_colors = pcall(require, "min-theme.colors")
if not min_colors_ok then
	debug_utils.log_debug("Failed to load min-theme.colors")
else
	colors = min_theme_colors
end

-- min-theme setup {{{
debug_utils.log_debug("Setting up min-theme...")
local min_theme_ok, min_theme = pcall(require, "min-theme")
if not min_theme_ok then
	debug_utils.log_debug("Failed to load min-theme")
else
	min_theme.setup({
		theme = "dark", -- String: 'dark' or 'light', determines the colorscheme used
		transparent = false, -- Boolean: Sets the background to transparent
		italics = {
			comments = true, -- Boolean: Italicizes comments
			keywords = true, -- Boolean: Italicizes keywords
			functions = true, -- Boolean: Italicizes functions
			strings = true, -- Boolean: Italicizes strings
			variables = true, -- Boolean: Italicizes variables
		},
		overrides = function()
			debug_utils.log_debug("Applying min-theme overrides...")
			return {
				-- FloatBorder customization
				["FloatBorder"] = { fg = colors.border, bg = colors.none },
				["IblIndent"] = { fg = colors.borderDarker },
				["NormalFloat"] = { fg = colors.fgCommand },
				["IblWhiteSpace"] = { fg = colors.borderDarker },
				["WhiteSpace"] = { fg = colors.fgDisbled },
				["@markup.heading.1.vimdoc"] = { fg = colors.fgCommand },
				["@markup.heading.3.vimdoc"] = { fg = colors.purple },
				["@label.vimdoc"] = { fg = colors.orange },
				["@markup.link.vimdoc"] = { fg = colors.blueLight },
				-- render-markdown set
				["RenderMarkdownH1"] = { fg = colors.fgCommand, bold = true },
				["RenderMarkdownH1Bg"] = { fg = colors.fgCommand, bg = colors.bgDarker },
				["RenderMarkdownH2"] = { fg = colors.fgCommand, bold = true },
				["RenderMarkdownH2Bg"] = { fg = colors.fgCommand, bg = colors.bgDarker },
				["RenderMarkdownH3"] = { fg = colors.fgCommand, bold = true },
				["RenderMarkdownH3Bg"] = { fg = colors.fgCommand, bg = colors.bgDarker },
				["RenderMarkdownH4"] = { fg = colors.fgCommand, bold = true },
				["RenderMarkdownH4Bg"] = { fg = colors.fgCommand, bg = colors.bgDarker },
				["RenderMarkdownH5"] = { fg = colors.fgCommand, bold = true },
				["RenderMarkdownH5Bg"] = { fg = colors.fgCommand, bg = colors.bgDarker },
				["RenderMarkdownH6"] = { fg = colors.fgCommand, bold = true },
				["RenderMarkdownH6Bg"] = { fg = colors.fgCommand, bg = colors.bgDarker },
				["RenderMarkdownCode"] = { bg = colors.bgDarker },
				["RenderMarkdownLink"] = { fg = colors.blue },
				["RenderMarkdownCodeInline"] = { fg = colors.symbol, bg = colors.borderDarker },
				["RenderMarkdownTableHead"] = { fg = colors.borderDarker },
				["RenderMarkdownTableRow"] = { fg = colors.borderDarker },
				["@markup.heading.1.markdown"] = { fg = colors.fgCommand, bold = true },
				["@markup.heading.2.markdown"] = { fg = colors.fgCommand, bold = true },
				["@markup.heading.3.markdown"] = { fg = colors.fgCommand, bold = true },
				["@markup.heading.4.markdown"] = { fg = colors.fgCommand, bold = true },
				["@markup.heading.5.markdown"] = { fg = colors.fgCommand, bold = true },
				["@markup.heading.6.markdown"] = { fg = colors.fgCommand, bold = true },
				["@markup.strong.markdown_inline"] = { fg = colors.fgSelection, bold = true },
				["@markup.italic.markdown_inline"] = { fg = colors.fgSelectionInactive, italic = true },
				["@markup.raw.block.markdown"] = { fg = colors.fgSelection },
				["@markup.link.markdown_inline"] = { underline = false },
				["@markup.link.label.markdown_inline"] = { fg = colors.blueLight, underline = false },
				["@markup.link.url.markdown_inline"] = { fg = colors.blue, underline = false },
				["@string.escape.markdown_inline"] = { fg = colors.fgDisabled },
			}
		end,
	})
end
debug_utils.log_debug("min-theme setup completed.")
-- }}}

-- lualine.nvim settings {{{
debug_utils.log_debug("Setting up lualine.nvim...")
local lualine_ok, lualine = pcall(require, "lualine")
if not lualine_ok then
	debug_utils.log_debug("Failed to load lualine.nvim")
else
	lualine.setup({
		options = {
			theme = "min-theme",
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
				},
			},
			lualine_c = {
				{
					"branch",
				},
				{
					"diff",
					colored = false,
					symbols = { added = " ", modified = " ", removed = " " },
				},
			},
			lualine_x = {
				"%=",
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
				},
				{
					"diagnostics",
					sources = { "nvim_diagnostic" },
					colored = false,
					symbols = { error = " ", warn = " ", info = " ", hint = " " },
				},
			},
			lualine_y = {
				{
					"filetype",
					colored = false,
				},
				{
					"progress",
				},
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
end
debug_utils.log_debug("lualine.nvim setup completed.")
-- }}}

-- bufferline.nvim settings {{{
debug_utils.log_debug("Setting up bufferline.nvim...")
local bufferline_ok, bufferline = pcall(require, "bufferline")
if not bufferline_ok then
	debug_utils.log_debug("Failed to load bufferline.nvim")
else
	bufferline.setup({
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
end
debug_utils.log_debug("bufferline.nvim setup completed.")
-- }}}

-- fidget.nvim settings - messages display {{{
debug_utils.log_debug("Setting up fidget.nvim...")
local fidget_ok, fidget = pcall(require, "fidget")
if not fidget_ok then
	debug_utils.log_debug("Failed to load fidget.nvim")
else
	fidget.setup({
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
				normal_hl = "fgCommand",
			},
		},
	})
end
debug_utils.log_debug("fidget.nvim setup completed.")
-- }}}

-- gitsign.nvim settings - git support {{{
debug_utils.log_debug("Setting up gitsigns.nvim...")
local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
if not gitsigns_ok then
	debug_utils.log_debug("Failed to load gitsigns.nvim")
else
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
			debug_utils.log_debug("Attaching gitsigns keymaps to buffer " .. bufnr)
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
end
debug_utils.log_debug("gitsigns.nvim setup completed.")
-- }}}

-- which-key.nvim settings {{{
debug_utils.log_debug("Setting up which-key.nvim...")
local which_key_ok, which_key = pcall(require, "which-key")
if not which_key_ok then
	debug_utils.log_debug("Failed to load which-key.nvim")
else
	which_key.setup({
		preset = "modern",
	})
end
debug_utils.log_debug("which-key.nvim setup completed.")
-- }}}
