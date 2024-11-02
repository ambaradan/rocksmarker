require("spectre").setup({
	live_update = false, -- auto execute search again when you write to any file in vim
})

local wk = require("which-key")
wk.add({
	{
		"<leader>R",
		'<cmd>lua require("spectre").toggle()<cr>',
		desc = "Toggle Spectre",
	},
	{
		"<leader>rw",
		'<cmd>lua require("spectre").open_visual({select_word=true})<cr>',
		desc = "Search current word",
	},
	{
		"<leader>rp",
		'<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
		desc = "Search on current file",
	},
})
