-- This script configures various Neovim plugins for code
-- diagnostics, formatting, and linting. It sets up conform
-- for formatting, nvim-lint for linting, and trouble for
-- diagnostic display.

-- conform.nvim settings - Formatting capabilities {{{
require("conform").setup({
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
-- }}}

-- nvim-lint.nvim settings - Linting capabilities  {{{

require("lint").linters_by_ft = {
	markdown = { "markdownlint", "vale" },
	yaml = { "yamllint" },
	bash = { "shellcheck" },
	json = { "jsonlint" },
	vim = { "vint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})
-- }}}

-- trouble.nvim settings - Diagnostic display {{{
require("trouble").setup()
-- }}}
