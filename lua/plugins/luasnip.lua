local ls = require("luasnip")
-- some shorthands...
local snip = ls.parser.parse_snippet
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
		-- snip({
		-- 	trig = "date",
		-- 	namr = "Date",
		-- 	dscr = "Date in the form of YYYY-MM-DD",
		-- }, {
		-- 	func(date, {}),
		-- }),
		--
		-- snip("shebang", {
		-- 	text("#!/usr/bin/env "), -- Shebang line
		-- 	insert(1, "sh"), -- Insert node for the shell type (default is sh)
		-- 	text({ "", "#", "" }), -- New lines for the description
		-- 	text("# "), -- Comment prefix for description
		-- 	insert(2, "Description of the script."), -- Insert node for the script description
		-- 	text({ "", "" }), -- Final new line to end the snippet
		-- }, {
		-- 	description = [[
		--           Shebang to specify what shell is going to run the script by default.
		--           It includes a description of the script.
		--
		--           It must be defined in the first line of the script.
		--
		--           By using #!/usr/bin/env we are making the shebang portable,
		--           meaning it is going to work correctly even if the interpreter
		--           is not located under /usr/bin.
		--       ]], -- Multi-line description
		-- }),

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
		snip("h1", "# ${1:Enter title header}"),
		snip("h2", "## ${1:Enter title header}"),
		snip("h3", "### ${1:Enter title header}"),
		snip("h4", "#### ${1:Enter title header}"),
		snip("h5", "##### ${1:Enter title header}"),
		snip("h6", "######## ${1:Enter title header}"),

		-- Links snippets
		snip("l", "[${1:alternate text}](${2})"),
		snip("link", "[${1:alternate text}](${2})"),
		-- URLs snippets
		snip("u", "<${1}> ${0}"),
		snip("url", "<${1}> ${0}"),
		-- Image snippet
		snip("img", "![${1:alt text}](${2:}) ${0}"),
		-- Text snippet
		snip("strikethrough", "~~${1}~~ ${0}"),
		snip("bold", "**${1}** ${0}"),
		snip("b", "**${1}** ${0}"),
		snip("i", "*${1}* ${0}"),
		snip("italic", "*${1}* ${0}"),
		snip("bold and italic", "***${1}*** ${0}"),
		snip("bi", "***${1}*** ${0}"),
		snip("quote", "> ${1}"),
		-- Code snippets
		snip("code", "`${1}` ${0}"),
		snip("codeblock", "```${1:language}\n$0\n```"),
		-- List snippets
		snip("unordered list", "- ${1:first}\n- ${2:second}\n- ${3:third}\n$0"),
		snip("ordered list", "1. ${1:first}\n2. ${2:second}\n3. ${3:third}\n$0"),
		-- 'mkdocs-material' custom snippets
		-- Admonitions snippets
		snip(
			"material_note",
			"!!! note ${1:Note title}\n\n\t" .. "${2:Text here - respect the four indentation spaces}"
		),
		snip(
			"material_abstract",
			'!!! abstract "${1:Abstract title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		snip("material_info", '!!! info "${1:Info title}"\n\n\t${2:Text here - respect the four indentation spaces}'),
		snip("material_tip", '!!! tip "${1:Tip title}"\n\n\t${2:Text here - respect the four indentation spaces}'),
		snip(
			"material_success",
			'!!! success "${1:Success title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		snip(
			"material_question",
			'!!! question "${1:Question title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		snip(
			"material_warning",
			'!!! warning "${1:Warning title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		snip(
			"material_failure",
			'!!! failure "${1:Failure title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		snip(
			"material_danger",
			'!!! danger "${1:Danger title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		snip("material_bug", '!!! bug "${1:Bug title}"\n\n\t${2:Text here - respect the four indentation spaces}'),
		snip(
			"material_example",
			'!!! example "${1:Example title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		snip(
			"material_quote",
			'!!! quote "${1:Quote title}"\n\n\t${2:Text here - respect the four indentation spaces}'
		),
		-- content tabs
		snip(
			"material_content_tab",
			'=== "${1:Tab one title}"\n\n\t'
				.. "${2:tab one content here}\n\n"
				.. '=== "${3:Tab two title}"\n\n\t'
				.. "${4:tab two content here}\n"
		),
		-- Keyboard snippet
		snip("kbd", "++${0:key}++"),
		-- Special text snippets
		snip("sub", "~${1:text}~"),
		snip("sup", "^${1:text}^"),
		snip("highlight", "==${0:highlight}=="),
		snip(
			"frontmatter",
			"---\n"
				.. "title: ${1:Title}\n"
				.. "author: ${2:author}\n"
				.. "contributors:\n"
				.. "tags:\n"
				.. "    - ${3:tag 1}\n"
				.. "    - ${4:tag 2}\n"
				.. "---"
		),
		snip("github_note", "> [!NOTE]\n" .. "> ${1:Note here}\n"),
		snip("github_tip", "> [!TIP]\n" .. "> ${1:Tip here}\n"),
		snip("github_warning", "> [!WARNING]\n" .. "> ${1:Warning here}\n"),
		snip("github_caution", "> [!CAUTION]\n" .. "> ${1:Warning here}\n"),
		-- Task snippets
		snip("task2", "- [${1| ,x|}] ${2:text}\n- [${3| ,x|}] ${4:text}\n${0}"),
		snip("task3", "- [${1| ,x|}] ${2:text}\n- [${3| ,x|}] ${4:text}\n- [${5| ,x|}] ${6:text}\n${0}"),
		snip(
			"task4",
			"- [${1| ,x|}] ${2:text}\n- [${3| ,x|}] ${4:text}\n- [${5| ,x|}] ${6:text}\n- [${7| ,x|}] ${8:text}\n${0}"
		),
		snip(
			"task5",
			"- [${1| ,x|}] ${2:text}\n- [${3| ,x|}] ${4:text}\n- [${5| ,x|}] ${6:text}\n- [${7| ,x|}] ${8:text}\n- [${9| ,x|}] ${10:text}\n${0}"
		),
	},
})
