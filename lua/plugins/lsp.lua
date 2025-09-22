-- lua/plugins/lsp.lua
-- This script configures the Language Server Protocol (LSP) settings for Neovim.
-- It includes debug logging for LSP events and performance.

local debug_utils = require("utils.debug")

-- nvim-lspconfig settings - LSP capabilities {{{
-- Use LspAttach autocommand to only map the following keys
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspAttachMap", { clear = true }),
	callback = function(event)
		debug_utils.log_debug("LSP attached to buffer: " .. vim.api.nvim_buf_get_name(event.buf))

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
		map("gr", [[<cmd>Telescope lsp_references theme=ivy<cr>]], "Goto References")
		map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
		map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")
		map("<leader>ds", "<cmd>Telescope lsp_document_symbols theme=dropdown<cr>", "Document Symbols")
		map("<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols theme=dropdown<cr>", "Workspace Symbols")

		-- Document highlight support
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.server_capabilities.documentHighlightProvider then
			debug_utils.log_debug("Enabling document highlight for client: " .. client.name)
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				callback = function()
					debug_utils.debug_execution_time(vim.lsp.buf.document_highlight)
				end,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				callback = function()
					debug_utils.debug_execution_time(vim.lsp.buf.clear_references)
				end,
			})
		end
	end,
})
-- }}}

-- LSP capabilities configuration
local capabilities = debug_utils.debug_execution_time(function()
	return require("blink.cmp").get_lsp_capabilities()
end)

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

debug_utils.log_table(capabilities, 0)

-- Setup language servers {{{
-- Lua language server
debug_utils.log_debug("Setting up Lua LSP...")
require("lspconfig").lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
			completion = {
				callSnippet = "Replace",
				displayContext = 5,
			},
			diagnostics = {
				globals = { "vim", "describe", "it", "before_each", "after_each" },
				disable = { "lowercase-global", "undefined-field" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
				ignoreDir = { ".git", "node_modules" },
				maxPreload = 2000,
				preloadFileSize = 500,
			},
			format = {
				enable = false,
			},
			telemetry = {
				enable = false,
			},
			hint = {
				enable = true,
				arrayIndex = "Enable",
				await = true,
				paramName = "All",
				paramType = true,
				semicolon = "SameLine",
				setType = true,
			},
		},
	},
	on_attach = function(_, bufnr)
		debug_utils.log_debug("Lua LSP attached to buffer: " .. vim.api.nvim_buf_get_name(bufnr))
	end,
})

-- Harper language server for grammar and style checking
debug_utils.log_debug("Setting up Harper LSP...")
require("lspconfig").harper_ls.setup({
	settings = {
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
			IgnoreCodeBlocks = true,
			IgnoreInlineCode = true,
			CheckLists = true,
			CheckHeadings = true,
		},
		diagnosticSeverity = "hint",
		isolateEnglish = true,
	},
	on_attach = function(_, bufnr)
		debug_utils.log_debug("Harper LSP attached to buffer: " .. vim.api.nvim_buf_get_name(bufnr))
	end,
})

-- Function and command for Harper LSP
require("utils.lsp_toggle")
-- }}}

-- Mason LSP-related {{{
debug_utils.log_debug("Setting up Mason...")
require("mason").setup({})
require("mason-lspconfig").setup({
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
			debug_utils.log_debug("Setting up LSP server: " .. server_name)
			require("lspconfig")[server_name].setup({
				capabilities = capabilities,
			})
		end,
	},
})

-- Mason tool installer for additional tools
debug_utils.log_debug("Setting up Mason tool installer...")
require("mason-tool-installer").setup({
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
debug_utils.log_debug("Setting up blink.cmp...")
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
				{ "kind_icon", "label", gap = 3 },
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
