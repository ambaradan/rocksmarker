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
-- 		-- Image snippet
-- 		snip("img", "![${1:alt text}](${2:}) ${0}"),
-- 		-- Text snippet
-- 		snip("strikethrough", "~~${1}~~ ${0}"),
-- 		snip("bold", "**${1}** ${0}"),
-- 		snip("b", "**${1}** ${0}"),
-- 		snip("i", "*${1}* ${0}"),
-- 		snip("italic", "*${1}* ${0}"),
-- 		snip("bold and italic", "***${1}*** ${0}"),
-- 		snip("bi", "***${1}*** ${0}"),
-- 		snip("quote", "> ${1}"),
-- 		-- Code snippets
-- 		snip("code", "`${1}` ${0}"),
-- 		snip("codeblock", "```${1:language}\n$0\n```"),
-- 		-- List snippets
-- 		snip("unordered list", "- ${1:first}\n- ${2:second}\n- ${3:third}\n$0"),
-- 		snip("ordered list", "1. ${1:first}\n2. ${2:second}\n3. ${3:third}\n$0"),
-- 		-- 'mkdocs-material' custom snippets
-- 		-- Admonitions snippets
-- 		snip(
-- 			"material_note",
-- 			"!!! note ${1:Note title}\n\n\t" .. "${2:Text here - respect the four indentation spaces}"
-- 		),
-- 		snip(
-- 			"material_abstract",
-- 			'!!! abstract "${1:Abstract title}"\n\n\t${2:Text here - respect the four indentation spaces}'
-- 		),
-- 		snip("material_info", '!!! info "${1:Info title}"\n\n\t${2:Text here - respect the four indentation spaces}'),
-- 		snip("material_tip", '!!! tip "${1:Tip title}"\n\n\t${2:Text here - respect the four indentation spaces}'),
-- 		snip(
-- 			"material_success",
-- 			'!!! success "${1:Success title}"\n\n\t${2:Text here - respect the four indentation spaces}'
-- 		),
-- 		snip(
-- 			"material_question",
-- 			'!!! question "${1:Question title}"\n\n\t${2:Text here - respect the four indentation spaces}'
-- 		),
-- 		snip(
-- 			"material_warning",
-- 			'!!! warning "${1:Warning title}"\n\n\t${2:Text here - respect the four indentation spaces}'
-- 		),
-- 		snip(
-- 			"material_failure",
-- 			'!!! failure "${1:Failure title}"\n\n\t${2:Text here - respect the four indentation spaces}'
-- 		),
-- 		snip(
-- 			"material_danger",
-- 			'!!! danger "${1:Danger title}"\n\n\t${2:Text here - respect the four indentation spaces}'
-- 		),
-- 		snip("material_bug", '!!! bug "${1:Bug title}"\n\n\t${2:Text here - respect the four indentation spaces}'),
-- 		snip(
-- 			"material_example",
-- 			'!!! example "${1:Example title}"\n\n\t${2:Text here - respect the four indentation spaces}'
-- 		),
-- 		snip(
-- 			"material_quote",
-- 			'!!! quote "${1:Quote title}"\n\n\t${2:Text here - respect the four indentation spaces}'
-- 		),
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
-- 		snip("highlight", "==${0:highlight}=="),
-- 		snip(
-- 			"frontmatter",
-- 			"---\n"
-- 				.. "title: ${1:Title}\n"
-- 				.. "author: ${2:author}\n"
-- 				.. "contributors:\n"
-- 				.. "tags:\n"
-- 				.. "    - ${3:tag 1}\n"
-- 				.. "    - ${4:tag 2}\n"
-- 				.. "---"
-- 		),
-- 		snip("github_note", "> [!NOTE]\n" .. "> ${1:Note here}\n"),
-- 		snip("github_tip", "> [!TIP]\n" .. "> ${1:Tip here}\n"),
-- 		snip("github_warning", "> [!WARNING]\n" .. "> ${1:Warning here}\n"),
-- 		snip("github_caution", "> [!CAUTION]\n" .. "> ${1:Warning here}\n"),
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
		s(
			{
				trig = "frontmatter",
				namr = "Frontmatter",
				dscr = "Create Rocky Frontmatter",
			},
			fmta(
				[[
                ---
                title: <1>
                author: <2>
                contributors: <3>
                tags:
                    - tag 1
                    - tag 2
                    - tag 3
                ---
                ]],
				{
					i(1, "Title of document"),
					i(2, "Author of the document"),
					i(3, "null"),
				}
			)
		),
		s(
			{
				trig = "admonition",
				namr = "Material Admonitions",
				dscr = "Add Material Admonition",
			},
			fmta(
				[[
                !!! <1> "Admonition Title"
                
                    Text here
                ]],
				{
					i(1, "note, abstract, info, tip, success, question, warning, failure, danger, bug, example, quote"),
				}
			)
		),
		s(
			{
				trig = "admonition",
				namr = "GitHub Admonition",
				dscr = "Add GitHub Admonition",
			},
			fmt(
				[[
                > [!{}]
                > {}
                ]],
				{
					i(1, "NOTE, TIP, IMPORTANT,WARNING,CAUTION"),
					i(2, "content here"),
				}
			)
		),
		s({
			trig = "bo",
			namr = "Bold Text",
			dscr = "Insert text in bold",
		}, {
			t("**"),
			i(1, "Text"),
			t("**"),
			i(0),
		}),
		s({
			trig = "it",
			namr = "Italic Text",
			dscr = "Insert text in italic",
		}, {
			t("*"),
			i(1, "Text"),
			t("*"),
			i(0),
		}),
	},
})
