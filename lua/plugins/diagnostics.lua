-- This script configures various Neovim plugins for code
-- diagnostics, formatting, and linting.

-- conform.nvim settings - Formatting capabilities {{{{
local conform_ok, conform = pcall(require, "conform")
if not conform_ok then
	return
end

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
		timeout_ms = 1000,
		lsp_format = "fallback",
	},
})
-- }}}

-- nvim-lint.nvim settings - Linting capabilities {{{{
local lint_ok, lint = pcall(require, "lint")
if not lint_ok then
	return
end

lint.linters_by_ft = {
	markdown = { "markdownlint", "vale" },
	yaml = { "yamllint" },
	bash = { "shellcheck" },
	json = { "jsonlint" },
	vim = { "vint" },
}

-- Configure specific options for markdownlint
lint.linters.markdownlint.args = {
	"--disable",
	"MD013", -- Disable rule MD013 (line length)
	"--disable",
	"MD046", -- Disable rule MD046 (code block style)
	"--",
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		lint.try_lint()
	end,
})
-- }}}

-- trouble.nvim settings - Diagnostic display {{{{
local trouble_ok, trouble = pcall(require, "trouble")
if not trouble_ok then
	return
end

trouble.setup()
-- }}}
