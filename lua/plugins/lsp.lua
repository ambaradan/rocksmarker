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

-- }}}

-- Setup language servers {{{

local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
		},
	},
})

-- Support for 'harper_ls'
lspconfig.harper_ls.setup({
	settings = {
		["harper-ls"] = {
			userDictPath = vim.fn.stdpath("config") .. "/spell/exceptions.utf-8.add",
			fileDictPath = vim.fn.stdpath("config") .. "/spell/file_dictionaries/",
			linters = {
				SpellCheck = true,
				SpelledNumbers = false,
				AnA = true,
				SentenceCapitalization = true,
				UnclosedQuotes = true,
				WrongQuotes = false,
				LongSentences = true,
				RepeatedWords = true,
				Spaces = true,
				Matcher = true,
				CorrectNumberSuffix = true,
			},
			codeActions = {
				ForceStable = false,
			},
			markdown = {
				IgnoreLinkTitle = false,
			},
			diagnosticSeverity = "hint",
			isolateEnglish = true,
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
	ensure_installed = { "lua_ls", "html", "cssls", "marksman", "harper_ls", "yamlls", "bashls", "taplo" },
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
local servers = { "lua_ls", "html", "cssls", "marksman", "harper_ls", "yamlls", "bashls", "taplo" }

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
		{ name = "lorem_ipsum" },
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

-- luasnip.lua settings - lua loader {{{

require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/snippets" })

-- }}}
