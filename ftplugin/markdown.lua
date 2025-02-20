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
		s(
			{
				trig = "sub",
				name = "Material Sub",
				dscr = "Insert subscripted text in Material format",
			},
			fmta("~<1>~", {
				i(1, "text"),
			})
		),
		s(
			{
				trig = "sup",
				name = "Material Sup",
				dscr = "Insert superscripted text in Material format",
			},
			fmta("^<1>^", {
				i(1, "text"),
			})
		),
		-- }}}
		-- material keyboard snippets {{{
		s(
			{
				trig = "kbd",
				name = "Material Keyboard",
				dscr = "Insert keyboard tag in Material format",
			},
			fmta("++<1>++", {
				i(1, "key"),
			})
		),
		s(
			{
				trig = "kbd",
				name = "Material Keyboard Expanded",
				dscr = "Multi keyboard tag in Material format",
			},
			fmta('++<1>+"<2>"+"<3>"++', {
				i(1, "key"),
				i(2, "letter"),
				i(3, "letter"),
			})
		),
		-- }}}
		-- lists snippets {{{
		s(
			{
				trig = "list",
				name = "Markdown Ordered List",
				dscr = "Insert a Markdown ordered list",
			},
			fmta(
				[[
    1. <item1>
    2. <item2>
    3. <item3>
    ]],
				{
					item1 = i(1, "First item"),
					item2 = i(2, "Second item"),
					item3 = i(3, "Third item"),
				}
			)
		),
		s(
			{
				trig = "list",
				name = "Markdown Nested Ordered List",
				dscr = "Insert a nested Markdown ordered list",
			},
			fmta(
				[[
    1. <item1>
      1. <subitem1>
      2. <subitem2>
    2. <item2>
      1. <subitem3>
      2. <subitem4>
    3. <item3>
    ]],
				{
					item1 = i(1, "First item"),
					subitem1 = i(2, "Sub-item 1"),
					subitem2 = i(3, "Sub-item 2"),
					item2 = i(4, "Second item"),
					subitem3 = i(5, "Sub-item 3"),
					subitem4 = i(6, "Sub-item 4"),
					item3 = i(7, "Third item"),
				}
			)
		),
		s(
			{
				trig = "list",
				name = "Markdown Unordered List",
				dscr = "Insert a Markdown unordered list",
			},
			fmta(
				[[
    - <item1>
    - <item2>
    - <item3>
    ]],
				{
					item1 = i(1, "First item"),
					item2 = i(2, "Second item"),
					item3 = i(3, "Third item"),
				}
			)
		),
		s(
			{
				trig = "list",
				name = "Markdown Nested Unordered List",
				dscr = "Insert a nested Markdown unordered list",
			},
			fmta(
				[[
    - <item1>
      - <subitem1>
      - <subitem2>
    - <item2>
      - <subitem3>
      - <subitem4>
    - <item3>
    ]],
				{
					item1 = i(1, "First item"),
					subitem1 = i(2, "Sub-item 1"),
					subitem2 = i(3, "Sub-item 2"),
					item2 = i(4, "Second item"),
					subitem3 = i(5, "Sub-item 3"),
					subitem4 = i(6, "Sub-item 4"),
					item3 = i(7, "Third item"),
				}
			)
		),
		-- }}}
		-- quote snippet {{{
		s(
			{
				trig = "quote",
				name = "Markdown Quote",
				dscr = "Insert a Markdown blockquote",
			},
			fmt("> {}", {
				i(1, "Your quote here"), -- Placeholder for the quote text
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
		-- code snippets {{{
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
				trig = "code",
				name = "Markdown `Inline Code`",
				dscr = "Insert inline code in Markdown format",
			},
			fmta("`<1>`", {
				i(1, "code here"),
			})
		),
		-- }}}
		-- task snippets {{{
		s(
			{
				trig = "task",
				name = "Markdown Task List",
				dscr = "Insert a Markdown task list",
			},
			fmta(
				[[
    - [ ] <task1>
    - [ ] <task2>
    - [ ] <task3>
    ]],
				{
					task1 = i(1, "First task"),
					task2 = i(2, "Second task"),
					task3 = i(3, "Third task"),
				}
			)
		),
		s(
			{
				trig = "task",
				name = "Markdown Nested Task List",
				dscr = "Insert a Markdown nested task list",
			},
			fmta(
				[[
- [ ] <main_task1>
    - [ ] <subtask1_1>
    - [ ] <subtask1_2>
- [ ] <main_task2>
    - [ ] <subtask2_1>
    - [ ] <subtask2_2>
            ]],
				{
					main_task1 = i(1, "Main Task 1"),
					subtask1_1 = i(2, "Subtask 1.1"),
					subtask1_2 = i(3, "Subtask 1.2"),
					main_task2 = i(4, "Main Task 2"),
					subtask2_1 = i(5, "Subtask 2.1"),
					subtask2_2 = i(6, "Subtask 2.2"),
				}
			)
		),
		-- }}}
		-- link and url snippets {{{
		s(
			{
				trig = "link",
				namr = "Markdown Link",
				dscr = "Create a Markdown link",
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
		s(
			{
				trig = "url",
				name = "Markdown Bare URL",
				dscr = "Insert a bare Markdown URL",
			},
			fmt("<{}>", {
				i(1, "http://example.com"),
			})
		),
		-- }}}
		-- material content tabs {{{
		s(
			{
				trig = "ctabs",
				name = "MkDocs Material Content Tabs",
				dscr = "Insert MkDocs Material content tabs",
			},
			fmta(
				[[
    === "<TabTitle1>"

        <content1>
    
    === "<TabTitle2>"

        <content2>
    ]],
				{
					TabTitle1 = i(1, "Tab Title 1"),
					content1 = i(2, "Content for Tab 1"),
					TabTitle2 = i(3, "TabTitle2"),
					content2 = i(4, "Content for Tab 2"),
				}
			)
		),
		-- }}}
		-- mermaid snippets {{{
		s(
			{
				trig = "mermaid",
				name = "Mermaid Flowchart",
				dscr = "Insert a horizontal flowchart diagram",
			},
			fmt(
				[[
```mermaid
graph LR
  A{} --> B{};
  B -->|Yes| C{};
  C --> D{};
  D --> B;
  B ---->|No| E{};
```
    ]],
				{
					i(1, "[Develop]"),
					i(2, "{Error}"),
					i(3, "[Fix]"),
					i(4, "[Debug]"),
					i(5, "[Update]"),
				}
			)
		),
		s(
			{
				trig = "mermaid",
				name = "Mermaid Flowchart",
				dscr = "Insert a vertical flowchart diagram",
			},
			fmt(
				[[
```mermaid
graph TB
  A{} --> B{};
  B -->|Yes| C{};
  C --> D{};
  D --> B;
  B ---->|No| E{};
```
    ]],
				{
					i(1, "[Develop]"),
					i(2, "{Error}"),
					i(3, "[Fix]"),
					i(4, "[Debug]"),
					i(5, "[Update]"),
				}
			)
		),
		-- }}}
	}, -- snippets mark
})
