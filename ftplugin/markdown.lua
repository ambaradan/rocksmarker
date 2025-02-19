vim.wo.list = true
vim.wo.listchars = "tab:» ,lead:•,trail:•"
vim.wo.wrap = true
vim.wo.linebreak = true
vim.wo.number = false
vim.wo.conceallevel = 2
vim.wo.scrolloff = 5
vim.wo.spell = true
vim.bo.spelllang = "en,it"
vim.bo.spellfile = vim.fn.stdpath("config") .. "/spell/exceptions.utf-8.add"

-- local ls = require("luasnip")
-- local snip = ls.parser.parse_snippet
--
-- ls.add_snippets(nil, {
-- 	all = {},
-- 	markdown = {
-- 		-- Headers snippets
-- 		snip("h1", "# ${1:Enter title header}"),
-- 		snip("h2", "## ${1:Enter title header}"),
-- 		snip("h3", "### ${1:Enter title header}"),
-- 		snip("h4", "#### ${1:Enter title header}"),
-- 		snip("h5", "##### ${1:Enter title header}"),
-- 		snip("h6", "######## ${1:Enter title header}"),
-- 		-- Links snippets
-- 		snip("l", "[${1:alternate text}](${2})"),
-- 		snip("link", "[${1:alternate text}](${2})"),
-- 		-- URLs snippets
-- 		snip("u", "<${1}> ${0}"),
-- 		snip("url", "<${1}> ${0}"),

-- 		snip("quote", "> ${1}"),
-- 		-- Code snippets
-- 		snip("code", "`${1}` ${0}"),
-- 		snip("codeblock", "```${1:language}\n$0\n```"),
-- 		-- List snippets
-- 		snip("unordered list", "- ${1:first}\n- ${2:second}\n- ${3:third}\n$0"),
-- 		snip("ordered list", "1. ${1:first}\n2. ${2:second}\n3. ${3:third}\n$0"),
--
-- 		-- content tabs
-- 		snip(
-- 			"material_content_tab",
-- 			'=== "${1:Tab one title}"\n\n\t'
-- 				.. "${2:tab one content here}\n\n"
-- 				.. '=== "${3:Tab two title}"\n\n\t'
-- 				.. "${4:tab two content here}\n"
-- 		),
-- 		-- Keyboard snippet
-- 		snip("kbd", "++${0:key}++"),
-- 		-- Special text snippets
-- 		snip("sub", "~${1:text}~"),
-- 		snip("sup", "^${1:text}^"),
-- 		-- Task snippets
-- 		snip("task2", "- [${1| ,x|}] ${2:text}\n- [${3| ,x|}] ${4:text}\n${0}"),
-- 		snip("task3", "- [${1| ,x|}] ${2:text}\n- [${3| ,x|}] ${4:text}\n- [${5| ,x|}] ${6:text}\n${0}"),
-- 		snip(
-- 			"task4",
-- 			"- [${1| ,x|}] ${2:text}\n- [${3| ,x|}] ${4:text}\n- [${5| ,x|}] ${6:text}\n- [${7| ,x|}] ${8:text}\n${0}"
-- 		),
-- 		snip(
-- 			"task5",
-- 			"- [${1| ,x|}] ${2:text}\n- [${3| ,x|}] ${4:text}\n- [${5| ,x|}] ${6:text}\n- [${7| ,x|}] ${8:text}\n- [${9| ,x|}] ${10:text}\n${0}"
-- 		),
-- 	},
-- })

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets(nil, {
	markdown = {
		-- frontmatter snippet {{{
		s(
			{
				trig = "frontmatter",
				namr = "Frontmatter",
				dscr = "Create RockyDocs Frontmatter",
			},
			fmta(
				[[
          ---
          title: <1>
          author: <2>
          contributors: <3>
          tags:
              - <4>
              - <5>
              - <6>
          ---
            ]],
				{
					i(1, "Title of document"),
					i(2, "Author of the document"),
					i(3, "null"),
					i(4, "tag 1"),
					i(5, "tag 2"),
					i(6, "tag 3"),
				}
			)
		),
		-- }}}
		-- Headers snippets {{{
		s(
			{
				trig = "h1",
				namr = "Markdown H1 Header",
				dscr = "Create a Markdown H1 header",
			},
			fmta("# <1>", {
				i(1, "Header text"),
			})
		),
		s(
			{
				trig = "h2",
				namr = "Markdown H2 Header",
				dscr = "Create a Markdown H2 header",
			},
			fmta("## <1>", {
				i(1, "Header text"),
			})
		),
		s(
			{
				trig = "h3",
				namr = "Markdown H3 Header",
				dscr = "Create a Markdown H3 header",
			},
			fmta("### <1>", {
				i(1, "Header text"),
			})
		),
		s(
			{
				trig = "h4",
				namr = "Markdown H4 Header",
				dscr = "Create a Markdown H4 header",
			},
			fmta("#### <1>", {
				i(1, "Header text"),
			})
		),
		s(
			{
				trig = "h5",
				namr = "Markdown H5 Header",
				dscr = "Create a Markdown H5 header",
			},
			fmta("##### <1>", {
				i(1, "Header text"),
			})
		),
		s(
			{
				trig = "h6",
				namr = "Markdown H6 Header",
				dscr = "Create a Markdown H6 header",
			},
			fmta("###### <1>", {
				i(1, "Header text"),
			})
		),
		-- }}}
		-- admonitions snippets {{{
		s(
			{
				trig = "admonition",
				namr = "**Material Admonitions**",
				dscr = [[
**Add Material Admonition**
**Available Types:**
*Note, Abstract, Info, Tip, Success, Question
Warning, Failure, Danger, Bug, Example, Quote*

        ]],
			},
			fmta(
				[[
          !!! <1> "<2>"
          
              <3>
          ]],
				{
					i(1, "Type"),
					i(2, "Admonition Title"),
					i(3, "Here the text, indentation of 4 spaces"),
				}
			)
		),
		s(
			{
				trig = "admonition",
				namr = "GitHub Admonition",
				dscr = [[
**Add GitHub Admonition**
**Available Types:**
*NOTE, TIP, IMPORTANT, WARNING, CAUTION

        ]],
			},
			fmt(
				[[
          > [!{}]
          > {}
          ]],
				{
					i(1, "Type"),
					i(2, "content here"),
				}
			)
		),
		-- }}}
		-- text format snippets {{{
		s(
			{
				trig = "bold",
				name = "Markdown **Bold**",
				dscr = "Insert bold text in Markdown format",
			},
			fmta("**<1>**", {
				i(1, "text"),
			})
		),
		s(
			{
				trig = "italic",
				name = "Markdown *Italic*",
				dscr = "Insert italic text in Markdown format",
			},
			fmta("*<1>*", {
				i(1, "text"),
			})
		),
		s(
			{
				trig = "bi",
				name = "Markdown ***Bold Italic***",
				dscr = "Insert bold italic text in Markdown format",
			},
			fmta("***<1>***", {
				i(1, "text"),
			})
		),
		s(
			{
				trig = "strikethrough",
				name = "Markdown ~~Strikethrough~~",
				dscr = "Insert strikethrough text in Markdown format",
			},
			fmta("~~<1>~~", {
				i(1, "text"),
			})
		),
		s(
			{
				trig = "highlight",
				name = "Material ==Highlight==",
				dscr = "Insert highlight text in Markdown format",
			},
			fmta("==<1>==", {
				i(1, "text"),
			})
		),
		-- }}}
		-- image snippet {{{
		s(
			{
				trig = "img",
				namr = "Add Image",
				dscr = "Add Markdown Image",
			},
			fmt(
				[[
                ![{}]({})
                ]],
				{
					i(1, "alternate text"),
					i(2, "image link"),
				}
			)
		),
		-- }}}
		-- inline code snippets {{{
		s(
			{
				trig = "codeblock",
				name = "Markdown Code Block",
				dscr = "Insert a code block in Markdown format",
			},
			fmta(
				[[
        ```<1>
        <2>
        ```
        ]],
				{
					i(1, "language"),
					i(2, "code here"),
				}
			)
		),
		s(
			{
				trig = "incode",
				name = "Markdown `Inline Code`",
				dscr = "Insert inline code in Markdown format",
			},
			fmta("`<1>`", {
				i(1, "code here"),
			})
		),
		-- }}}
		s(
			{
				trig = "link", -- Trigger for the snippet
				namr = "Markdown Link", -- Name of the snippet
				dscr = "Create a Markdown link", -- Description of the snippet
			},
			fmt(
				[[
                [{}]({})
                ]],
				{
					i(1, "text link"),
					i(2, "http://example.com"),
				}
			)
		),
		s({
			trig = "link",
			namr = "markdown_link",
			dscr = "Create markdown link [txt](url)",
		}, {
			t("["),
			i(1),
			t("]("),
			f(function(_, snip)
				return snip.env.TM_SELECTED_TEXT[1] or {}
			end, {}),
			t(")"),
			i(0),
		}),
	}, -- snippets mark
})
