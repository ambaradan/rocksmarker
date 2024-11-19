require("peek").setup({
	-- build = "~/.local/share/rprod/mason/bin/deno task --quiet build:fast",
	vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {}),
	vim.api.nvim_create_user_command("PeekClose", require("peek").close, {}),
})
