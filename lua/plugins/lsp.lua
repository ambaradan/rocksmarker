-- This script configures the Language Server Protocol (LSP)
-- settings for Neovim. It sets up the LSP capabilities,
-- language servers, and other LSP-related settings.

-- nvim-lspconfig settings - LSP capabilities {{{
-- Use LspAttach autocommand to only map the following keys
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspAttachMap", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "Lsp: " .. desc })
		end

		-- Key mappings for LSP features
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

		-- Document highlight support
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

-- LSP capabilities configuration
local capabilities = require("blink.cmp").get_lsp_capabilities()
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
-- Lua language server
require("lspconfig").lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
		},
	},
})

-- Vale language server for Markdown and Git commit messages
require("lspconfig").vale_ls.setup({
	capabilities = capabilities,
	filetypes = { "markdown", "gitcommit" },
})

-- Harper language server for grammar and style checking
require("lspconfig").harper_ls.setup({
	settings = {
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
})
-- }}}

-- mason LSP-related {{{
-- Mason setup for managing LSP servers
require("mason").setup({})
require("mason-lspconfig").setup({
	-- List of LSP servers to ensure are installed
	ensure_installed = {
		"lua_ls",
		"html",
		"cssls",
		"marksman",
		"harper_ls",
		"yamlls",
		"bashls",
		"taplo",
		"jsonls",
		"vimls",
	},
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({
				capabilities = capabilities,
			})
		end,
	},
})

-- Mason tool installer for additional tools
require("mason-tool-installer").setup({
	-- List of tools to ensure are installed
	ensure_installed = {
		"markdownlint",
		"vale",
		"stylua",
		"shfmt",
		"yamlfmt",
		"shellcheck",
		"prettier",
		"yamllint",
		"jsonlint",
		"vint",
	},
})
-- }}}

-- Autocompletion features - blink.cmp {{{
-- Setup for autocompletion using blink.cmp
require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
		["<ESC>"] = { "cancel", "fallback" },
	},
	completion = {
		menu = {
			scrollbar = false,
			draw = {
				treesitter = { "lsp" },
			},
			columns = {
				{ "kind_icon", "label", gap = 1 },
				{ "source_name" },
			},
			ghost_text = {
				enabled = true,
			},
		},
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	cmdline = {
		keymap = { preset = "super-tab" },
		completion = { menu = { auto_show = true } },
	},
	fuzzy = { implementation = "lua" },
})
-- }}}
