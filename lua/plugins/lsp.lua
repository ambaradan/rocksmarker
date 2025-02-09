-- nvim-lspconfig settings - LSP capabilities {{{
-- -- Reserve a space in the gutter
-- -- This will avoid an annoying layout shift in the screen
-- vim.opt.signcolumn = "yes"
-- Use LspAttach autocommand to only map the following keys
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspAttachMap", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "Lsp: " .. desc })
		end
		map("gd", vim.lsp.buf.definition, "Goto Definition")
		map("K", vim.lsp.buf.hover, "Hover Documentation")
		map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")
		map("<leader>rn", vim.lsp.buf.rename, "Rename")
		map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
		map("gD", vim.lsp.buf.declaration, "Goto Declaration")
		map("gr", "<cmd>Telescope lsp_references theme=ivy<cr>", "Goto References")
		map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
		map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")
		map("<leader>ds", "<cmd>Telescope lsp_document_symbols theme=dropdown<cr>", "Document Symbols")
		map("<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols theme=dropdown<cr>", "Workspace Symbols")
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.server_capabilities.documentHighlightProvider then
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})

-- capabilities setting
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

-- Setup language servers.
local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
		},
	},
})
-- }}}

-- mason and mason-lspconfig settings - ensure_installed servers {{{
-- IMPORTANT - setting servers to be installed
-- with mason-lspconfig be done after setting 'capabilities'
require("mason").setup({})
require("mason-lspconfig").setup({
	-- Replace the language servers listed here
	-- with the ones you want to install
	ensure_installed = { "lua_ls", "html", "cssls", "marksman", "yamlls", "bashls", "taplo" },
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
	},
})
-- }}}

-- mason-tool-installer - LSPs for 'nvim-lint' and 'conform' {{{
require("mason-tool-installer").setup({
	-- a list of all tools you want to ensure are installed upon
	-- start
	ensure_installed = {
		"markdownlint",
		"vale",
		"stylua",
		"shfmt",
		"yamlfmt",
		"shellcheck",
		"prettier",
		"yamllint",
	},
})
-- setup multiple servers with same default options
local servers = { "lua_ls", "html", "cssls", "marksman", "yamlls", "bashls", "taplo" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		capabilities = capabilities,
	})
end
-- }}}

-- nvim-cmp settings - snippets support {{{
local cmp = require("cmp")
local luasnip = require("luasnip")

local select_opts = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	sources = {
		{ name = "path" },
		{ name = "nvim_lsp", keyword_length = 1 },
		{ name = "buffer", keyword_length = 3 },
		{ name = "luasnip", keyword_length = 2 },
	},
	window = {
		documentation = cmp.config.window.bordered(),
	},
	formatting = {
		fields = { "menu", "abbr", "kind" },
		format = function(entry, item)
			local menu_icon = {
				nvim_lsp = "λ",
				luasnip = "⋗",
				buffer = "Ω",
				path = "",
			}

			item.menu = menu_icon[entry.source.name]
			return item
		end,
	},
	mapping = {
		["<Up>"] = cmp.mapping.select_prev_item(select_opts),
		["<Down>"] = cmp.mapping.select_next_item(select_opts),

		["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
		["<C-n>"] = cmp.mapping.select_next_item(select_opts),

		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),

		["<C-e>"] = cmp.mapping.abort(),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<CR>"] = cmp.mapping.confirm({ select = false }),

		["<C-f>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(1) then
				luasnip.jump(1)
			else
				fallback()
			end
		end, { "i", "s" }),

		["<C-b>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),

		["<Tab>"] = cmp.mapping(function(fallback)
			local col = vim.fn.col(".") - 1

			if cmp.visible() then
				cmp.select_next_item(select_opts)
			elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
				fallback()
			else
				cmp.complete()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item(select_opts)
			else
				fallback()
			end
		end, { "i", "s" }),
	},
})
-- }}}

-- luasnip.lua settings - markdown snippets {{{
local ls = require("luasnip")
local snip = ls.parser.parse_snippet

ls.add_snippets(nil, {
	all = {},
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
-- }}}
