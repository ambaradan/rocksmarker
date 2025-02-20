vim.bo.expandtab = true
vim.bo.autoindent = true
vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

ls.add_snippets(nil, {
	sh = {
		s(
			{
				trig = "shebang",
				namr = "Shebang Line",
				dscr = [[
Insert a shebang line for scripts
Common choices: *bash, python, sh, zsh*
        ]],
			},
			fmta(
				[[
                #!/bin/env <1>
                ]],
				{
					i(1, "bash"),
				}
			)
		),
	},
})
