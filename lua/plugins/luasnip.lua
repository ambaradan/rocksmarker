local ls = require("luasnip")
-- some shorthands...
local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node

local date = function()
	return { os.date("%Y-%m-%d") }
end

ls.add_snippets(nil, {
	all = {
		snip({
			trig = "date",
			namr = "Date",
			dscr = "Date in the form of YYYY-MM-DD",
		}, {
			func(date, {}),
		}),

		snip("shebang", {
			text("#!/usr/bin/env "), -- Shebang line
			insert(1, "sh"), -- Insert node for the shell type (default is sh)
			text({ "", "#", "" }), -- New lines for the description
			text("# "), -- Comment prefix for description
			insert(2, "Description of the script."), -- Insert node for the script description
			text({ "", "" }), -- Final new line to end the snippet
		}, {
			description = [[
            Shebang to specify what shell is going to run the script by default.
            It includes a description of the script.

            It must be defined in the first line of the script.

            By using #!/usr/bin/env we are making the shebang portable,
            meaning it is going to work correctly even if the interpreter
            is not located under /usr/bin.
        ]], -- Multi-line description
		}),

		-- snip({
		-- 	trig = "shebang",
		-- 	namr = "Shebang",
		-- 	dscr = "Add Shebang",
		-- }, {
		-- 	text({ "#!/bin/env bash", "" }),
		-- 	insert(0),
		-- }),
	},
	markdown = {
		-- Headers snippets
		ls.parser.parse_snippet("h1", "# ${1:Enter title header}"),
		ls.parser.parse_snippet("h2", "## ${1:Enter title header}"),
		ls.parser.parse_snippet("h3", "### ${1:Enter title header}"),
		ls.parser.parse_snippet("h4", "#### ${1:Enter title header}"),
		ls.parser.parse_snippet("h5", "##### ${1:Enter title header}"),
		ls.parser.parse_snippet("h6", "######## ${1:Enter title header}"),

		-- Links snippets
		ls.parser.parse_snippet("l", "[${1:alternate text}](${2})"),
		ls.parser.parse_snippet("link", "[${1:alternate text}](${2})"),
		-- URLs snippets
		ls.parser.parse_snippet("u", "<${1}> ${0}"),
		ls.parser.parse_snippet("url", "<${1}> ${0}"),
		-- Image snippet
		ls.parser.parse_snippet("img", "![${1:alt text}](${2:}) ${0}"),
		-- Text snippet
		ls.parser.parse_snippet("strikethrough", "~~${1}~~ ${0}"),
		ls.parser.parse_snippet("bold", "**${1}** ${0}"),
		ls.parser.parse_snippet("b", "**${1}** ${0}"),
		ls.parser.parse_snippet("i", "*${1}* ${0}"),
		ls.parser.parse_snippet("italic", "*${1}* ${0}"),
		ls.parser.parse_snippet("bold and italic", "***${1}*** ${0}"),
		ls.parser.parse_snippet("bi", "***${1}*** ${0}"),
		ls.parser.parse_snippet("quote", "> ${1}"),
		-- Code snippets
		ls.parser.parse_snippet("code", "`${1}` ${0}"),
		ls.parser.parse_snippet("codeblock", "```${1:language}\n$0\n```"),
		-- List snippets
		ls.parser.parse_snippet("unordered list", "- ${1:first}\n- ${2:second}\n- ${3:third}\n$0"),
		ls.parser.parse_snippet("ordered list", "1. ${1:first}\n2. ${2:second}\n3. ${3:third}\n$0"),
		-- 'mkdocs-material' custom snippets
		-- Admonitions snippets
		ls.parser.parse_snippet(
			"note",
			'!!! note "${1:Note title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		ls.parser.parse_snippet(
			"abstract",
			'!!! abstract "${1:Abstract title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		ls.parser.parse_snippet(
			"info",
			'!!! info "${1:Info title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		ls.parser.parse_snippet(
			"tip",
			'!!! tip "${1:Tip title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		ls.parser.parse_snippet(
			"success",
			'!!! success "${1:Success title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		ls.parser.parse_snippet(
			"question",
			'!!! question "${1:Question title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		ls.parser.parse_snippet(
			"warning",
			'!!! warning "${1:Warning title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		ls.parser.parse_snippet(
			"failure",
			'!!! failure "${1:Failure title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		ls.parser.parse_snippet(
			"danger",
			'!!! danger "${1:Danger title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		ls.parser.parse_snippet(
			"bug",
			'!!! bug "${1:Bug title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		ls.parser.parse_snippet(
			"example",
			'!!! example "${1:Example title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		ls.parser.parse_snippet(
			"quote",
			'!!! quote "${1:Quote title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		-- Keyboard snippet
		ls.parser.parse_snippet("kbd", "++${0:key}++"),
		-- Special text snippets
		ls.parser.parse_snippet("sub", "${1}&lt;sub&gt;${0}"),
		ls.parser.parse_snippet("sup", "${1}&lt;sup&gt;${0}"),
		ls.parser.parse_snippet("highlight", "==${0:highlight}=="),
		-- Task snippets
		ls.parser.parse_snippet("task2", "- [${1| ,x|}] ${2:text}\n- [${3| ,x|}] ${4:text}\n${0}"),
		ls.parser.parse_snippet(
			"task3",
			"- [${1| ,x|}] ${2:text}\n- [${3| ,x|}] ${4:text}\n- [${5| ,x|}] ${6:text}\n${0}"
		),
		ls.parser.parse_snippet(
			"task4",
			"- [${1| ,x|}] ${2:text}\n- [${3| ,x|}] ${4:text}\n- [${5| ,x|}] ${6:text}\n- [${7| ,x|}] ${8:text}\n${0}"
		),
		ls.parser.parse_snippet(
			"task5",
			"- [${1| ,x|}] ${2:text}\n- [${3| ,x|}] ${4:text}\n- [${5| ,x|}] ${6:text}\n- [${7| ,x|}] ${8:text}\n- [${9| ,x|}] ${10:text}\n${0}"
		),
	},
})
