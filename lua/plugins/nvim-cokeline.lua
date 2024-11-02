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

local wk = require("which-key")
wk.add({
	{ "<Tab>", "<Plug>(cokeline-focus-next)", desc = "next buffer" },
	{ "<S-Tab>", "<Plug>(cokeline-focus-prev)", desc = "prev buffer" },
})

-- TODO

--https://github.com/noib3/nvim-cokeline#musical_keyboard-mappings
-- local map = vim.api.nvim_set_keymap
--
-- --map("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", { silent = true })
-- --map("n", "<Tab>", "<Plug>(cokeline-focus-next)", { silent = true })
--
-- for i = 1, 9 do
-- 	map("n", ("<Leader>%s"):format(i), ("<Plug>(cokeline-focus-%s)"):format(i), { silent = true })
-- end
