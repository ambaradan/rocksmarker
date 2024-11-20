-- conform.nvim settings
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

-- nvim-lint.nvim settings
require("lint").linters_by_ft = {
	markdown = { "markdownlint", "vale" },
	yaml = { "yamllint" },
	bash = { "shellcheck" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

-- trouble.nvim settings
require("trouble").setup()
