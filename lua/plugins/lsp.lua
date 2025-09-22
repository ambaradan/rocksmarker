-- lua/plugins/lsp.lua
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
	capabilities = capabilities, -- Use the capabilities defined earlier for LSP features
	settings = {
		Lua = {
			-- Runtime configuration for Lua
			runtime = {
				version = "LuaJIT", -- Use LuaJIT for Neovim compatibility
				path = vim.split(package.path, ";"), -- Set Lua package paths for module resolution
			},
			-- Completion settings for better suggestions
			completion = {
				callSnippet = "Replace", -- Replace existing text with snippet
				displayContext = 5, -- Show 5 lines of context in completion
			},
			-- Diagnostics configuration to handle globals and warnings
			diagnostics = {
				globals = { "vim", "describe", "it", "before_each", "after_each" }, -- Recognize additional globals (e.g., for testing)
				disable = { "lowercase-global", "undefined-field" }, -- Disable specific warnings
			},
			-- Workspace settings to manage library paths and performance
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true, -- Include Neovim's Lua runtime files
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true, -- Include Neovim's LSP-related Lua files
					-- Add other custom paths if needed (e.g., for plugins or projects)
				},
				ignoreDir = { ".git", "node_modules" }, -- Ignore specific directories for performance
				maxPreload = 2000, -- Limit memory usage (in KB)
				preloadFileSize = 500, -- Limit file size for preloading (in KB)
			},
			-- Disable built-in formatting to avoid conflicts with stylua
			format = {
				enable = false, -- Disable LuaLS formatting (use stylua instead)
			},
			-- Disable telemetry for privacy
			telemetry = {
				enable = false,
			},
			-- Enable hints for better code suggestions
			hint = {
				enable = true, -- Enable inline hints
				arrayIndex = "Enable", -- Show hints for array indices
				await = true, -- Show hints for `await` usage
				paramName = "All", -- Show hints for parameter names
				paramType = true, -- Show hints for parameter types
				semicolon = "SameLine", -- Show hints for semicolons
				setType = true, -- Show hints for set types
			},
		},
	},
})

-- Harper language server for grammar and style checking
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
			IgnoreLinkTitle = false, -- Check link titles for errors
			IgnoreCodeBlocks = true, -- Ignore code blocks (avoid false positives)
			IgnoreInlineCode = true, -- Ignore inline code (e.g., `code`)
			CheckLists = true, -- Validate list formatting
			CheckHeadings = true, -- Validate heading capitalization and formatting
		},
		diagnosticSeverity = "hint",
		isolateEnglish = true,
	},
})

-- Load the utils.lsp_toggle module
local lsp_toggle = require("utils.lsp-toggle")

-- Create custom commands to enable, disable, and toggle harper_ls
vim.api.nvim_create_user_command("HarperEnable", lsp_toggle.enable_harper_ls, {})
vim.api.nvim_create_user_command("HarperDisable", lsp_toggle.disable_harper_ls, {})
vim.api.nvim_create_user_command("HarperToggle", lsp_toggle.toggle_harper_ls, {})

-- (Optional) Key mapping to toggle harper_ls
-- vim.keymap.set("n", "<leader>th", lsp_toggle.toggle_harper_ls, { desc = "Toggle harper_ls" })

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
