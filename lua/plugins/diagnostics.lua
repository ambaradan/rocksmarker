-- lua/plugins/diagnostic.lua
-- This script configures various Neovim plugins for code
-- diagnostics, formatting, and linting, with debug logging.

local debug_utils = require("utils.debug")

-- conform.nvim settings - Formatting capabilities {{{
debug_utils.log_debug("Setting up conform.nvim for formatting...")
local conform_ok, conform = pcall(require, "conform")
if not conform_ok then
	debug_utils.log_debug("Failed to load conform.nvim")
else
	conform.setup({
		formatters_by_ft = {
			lua = { "stylua" },
			css = { "prettier" },
			html = { "prettier" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			markdown = { "markdownlint" },
			yaml = { "yamlfmt" },
		},
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 1000,
			lsp_format = "fallback",
		},
	})
end
debug_utils.log_debug("Conform.nvim setup completed.")
-- }}}

-- nvim-lint.nvim settings - Linting capabilities {{{
debug_utils.log_debug("Setting up nvim-lint for linting...")
local lint_ok, lint = pcall(require, "lint")
if not lint_ok then
	debug_utils.log_debug("Failed to load nvim-lint")
else
	lint.linters_by_ft = {
		markdown = { "markdownlint", "vale" },
		yaml = { "yamllint" },
		bash = { "shellcheck" },
		json = { "jsonlint" },
		vim = { "vint" },
	}

	-- Configure specific options for markdownlint
	debug_utils.log_debug("Configuring markdownlint options...")
	lint.linters.markdownlint.args = {
		"--disable",
		"MD013", -- Disable rule MD013 (line length)
		"--disable",
		"MD046", -- Disable rule MD046 (code block style)
		"--",
	}

	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		callback = function()
			debug_utils.log_debug("Running linter after buffer save...")
			debug_utils.debug_execution_time(function()
				lint.try_lint()
			end)
		end,
	})
end
debug_utils.log_debug("nvim-lint setup completed.")
-- }}}

-- trouble.nvim settings - Diagnostic display {{{
debug_utils.log_debug("Setting up trouble.nvim for diagnostics display...")
local trouble_ok, trouble = pcall(require, "trouble")
if not trouble_ok then
	debug_utils.log_debug("Failed to load trouble.nvim")
else
	trouble.setup()
end
debug_utils.log_debug("Trouble.nvim setup completed.")
-- }}}
