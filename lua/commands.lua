-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = vim.api.nvim_create_augroup("checktime", { clear = true }),
	callback = function()
		if vim.o.buftype ~= "c" then
			vim.cmd("checktime")
		end
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"startuptime",
		"checkhealth",
		"spectre_panel",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- vertical help
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("vertical_help", { clear = true }),
	pattern = "help",
	callback = function()
		vim.bo.bufhidden = "unload"
		vim.cmd.wincmd("L")
		vim.cmd.wincmd("=")
	end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("markdown_set", { clear = true }),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.wo.list = true
		vim.wo.listchars = "tab:» ,lead:•,trail:•"
		vim.wo.wrap = true
		vim.wo.linebreak = true
		vim.wo.number = false
		vim.wo.conceallevel = 2
		vim.wo.scrolloff = 5
		vim.wo.spell = true
		vim.bo.spelllang = "en,it"
		vim.bo.spellfile = vim.fn.stdpath("config") .. "/spell/exceptions.utf-8.add"
	end,
})

-- indent with 2 spaces for these file types
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("indent_set", { clear = true }),
	pattern = { "yaml", "yml", "sh", "lua" },
	callback = function()
		vim.bo.shiftwidth = 2
		vim.bo.tabstop = 2
	end,
})

-- no spell for terminal buffer
vim.api.nvim_create_autocmd({ "TermOpen" }, {
	group = vim.api.nvim_create_augroup("spell_off", { clear = true }),
	callback = function()
		vim.wo.spell = false
	end,
})
