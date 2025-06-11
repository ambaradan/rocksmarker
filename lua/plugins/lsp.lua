-- This script configures the Language Server Protocol (LSP)
-- settings for Neovim. It sets up the LSP capabilities,
-- language servers, and other LSP-related settings.

-- nvim-lspconfig settings - LSP capabilities {{{

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
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

vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
		},
	},
})

vim.lsp.config("vale_ls", {
	capabilities = capabilities,
	filetypes = { "markdown", "gitcommit" },
})

-- Support for 'harper_ls'
vim.lsp.config("harper_ls", {
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

-- mason and mason-lspconfig settings - ensure_installed servers {{{
-- IMPORTANT - setting servers to be installed
-- with mason-lspconfig be done after setting 'capabilities'
-- local lspconfig = require("lspconfig")
require("mason").setup({})
require("mason-lspconfig").setup({
	-- Replace the language servers listed here
	-- with the ones you want to install
	ensure_installed = { "lua_ls", "html", "cssls", "marksman", "harper_ls", "yamlls", "bashls", "taplo" },
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

-- }}}

-- Autocompletion features - blink.cmp {{{

require("blink.cmp").setup({
	keymap = {
		preset = "default",
	},
	completion = {
		trigger = {
			-- show_on_trigger_character = true,
			-- show_on_accept_on_trigger_character = true
		},
		menu = {
			-- auto_show = true,
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
		keymap = { preset = "inherit" },
		completion = { menu = { auto_show = true } },
	},
	fuzzy = { implementation = "lua" },
})

-- }}}
