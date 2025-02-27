require("luasnip.session.snippet_collection").clear_snippets("asciidoc")

local ls = require("luasnip")
local s = ls.snippet
-- local sn = ls.snippet_node
-- local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta
-- local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets(nil, {
	asciidoc = {
		-- Headers snippets {{{
		s(
			{
				trig = "h1",
				namr = "Markdown H1 Header",
				dscr = "Create a Markdown H1 header",
			},
			fmta("= <1>", {
				i(1, "Header text"),
			})
		),
		s(
			{
				trig = "h2",
				name = "Asciidoc H2 Header",
				dscr = "Create a Asciidoc H2 header",
			},
			fmta("== <1>", {
				i(1, "Header text"),
			})
		),
		s(
			{
				trig = "h3",
				name = "Asciidoc H3 Header",
				dscr = "Create a Asciidoc H3 header",
			},
			fmta("=== <1>", {
				i(1, "Header text"),
			})
		),
		s(
			{
				trig = "h4",
				name = "Asciidoc H4 Header",
				dscr = "Create a Asciidoc H4 header",
			},
			fmta("==== <1>", {
				i(1, "Header text"),
			})
		),
		s(
			{
				trig = "h5",
				name = "Asciidoc H5 Header",
				dscr = "Create a Asciidoc H5 header",
			},
			fmta("===== <1>", {
				i(1, "Header text"),
			})
		),
		s(
			{
				trig = "h6",
				name = "Asciidoc H6 Header",
				dscr = "Create a Asciidoc H6 header",
			},
			fmta("====== <1>", {
				i(1, "Header text"),
			})
		),
		-- }}}
		-- Formatting snippets {{{
		s(
			{
				trig = "bold",
				name = "Asciidoc Bold",
				dscr = "Create Asciidoc bold text",
			},
			fmta("*<1>*", {
				i(1, "Bold text"),
			})
		),
		s(
			{
				trig = "italic",
				name = "Asciidoc Bold Italic",
				dscr = "Create Asciidoc bold italic text",
			},
			fmta("_<1>_", {
				i(1, "Bold italic text"),
			})
		),
		s(
			{
				trig = "sup",
				name = "Asciidoc Superscript",
				dscr = "Create Asciidoc superscript text",
			},
			fmta("^<1>^", {
				i(1, "Superscript text"),
			})
		),
		s(
			{
				trig = "sub",
				name = "Asciidoc Subscript",
				dscr = "Create Asciidoc subscript text",
			},
			fmta("~<1>~", {
				i(1, "Subscript text"),
			})
		),
		-- }}}
		-- List snippet {{{
		s(
			{
				trig = "list",
				name = "Unordered List",
				dscr = "Create an Asciidoc unordered list",
			},
			fmta(
				[[
            * <1>
            * <2>
            * <3>
            ]],
				{
					i(1, "List item 1"),
					i(2, "List item 2"),
					i(3, "List item 3"),
				}
			)
		),
		s(
			{
				trig = "list",
				namr = "Ordered List",
				dscr = "Create an Asciidoc ordered list",
			},
			fmta(
				[[
            . <1>
            . <2>
            . <3>
            ]],
				{
					i(1, "Item 1"),
					i(2, "Item 2"),
					i(3, "Item 3"),
				}
			)
		),
		-- }}}
		-- admonitions snippets {{{
		s(
			{
				trig = "note",
				namr = "Asciidoc Note Admonition",
				dscr = "Create a Asciidoc note admonition",
			},
			fmta("[NOTE]\n====\n<1>\n====", {
				i(1, "Note content"),
			})
		),
		s(
			{
				trig = "tip",
				namr = "Asciidoc Tip Admonition",
				dscr = "Create a Asciidoc tip admonition",
			},
			fmta("[TIP]\n====\n<1>\n====", {
				i(1, "Tip content"),
			})
		),
		s(
			{
				trig = "warning",
				namr = "Asciidoc Warning Admonition",
				dscr = "Create a Asciidoc warning admonition",
			},
			fmta("[WARNING]\n====\n<1>\n====", {
				i(1, "Warning content"),
			})
		),

		-- }}}
		-- Table snippet {{{
		s(
			{
				trig = "table",
				name = "Asciidoc Table",
				dscr = "Create an Asciidoc table",
			},
			fmta(
				[[
|===
| <1> | <2>
| <3> | <4>
|===
]],
				{
					i(1, "Column 1 header"),
					i(2, "Column 2 header"),
					i(3, "Row 1 data"),
					i(4, "Row 2 data"),
				}
			)
		),
	},
})
