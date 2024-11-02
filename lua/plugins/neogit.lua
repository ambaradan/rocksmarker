require("neogit").setup({
	kind = "tab",
	disable_builtin_notifications = true,
	graph_style = "unicode",
	integrations = {
		telescope = true,
		diffview = true,
	},
	status = {
		-- show_head_commit_hash = true,
		recent_commit_count = 20,
	},
	commit_view = {
		kind = "floating",
		verify_commit = vim.fn.executable("gpg") == 1,
	},
	-- commit_editor = {
	-- 	kind = "floating",
	-- },
})

local wk = require("which-key")
wk.add({
	{ "<leader>gg", "<cmd>Neogit<cr>", desc = "git manager" },
	-- { "<leader>gc", "<cmd>Neogit cwd=%:p:h<cr>", "git current file" },
})
