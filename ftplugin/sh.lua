vim.bo.expandtab = true
vim.bo.autoindent = true
vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2

local ls = require("luasnip")
local textnode = ls.text_node
local snippet = ls.s

ls.add_snippets("sh", {
	snippet({ trig = "#!" }, {
		textnode("#!/usr/bin/env bash"),
	}),
})
