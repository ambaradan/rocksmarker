local augroup = vim.api.nvim_create_augroup("RocksmarkerSet", { clear = true })

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup,
	desc = "Reload files when focus is regained or terminal interactions occur",
	callback = function()
		if vim.o.buftype ~= "c" then
			vim.cmd("checktime")
		end
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	desc = "Allow closing specific utility buffers with 'q' key",
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
	group = augroup,
	desc = "Highlight text after yanking to provide visual feedback",
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- vertical help
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	desc = "Open help documents in a vertical split and equalize window sizes",
	pattern = "help",
	callback = function()
		vim.bo.bufhidden = "unload"
		vim.cmd.wincmd("L")
		vim.cmd.wincmd("=")
	end,
})

-- no spell for terminal buffer
vim.api.nvim_create_autocmd({ "TermOpen" }, {
	group = augroup,
	desc = "Disable spell checking when opening terminal buffers",
	callback = function()
		vim.wo.spell = false
	end,
})
