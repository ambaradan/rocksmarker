-- Rocksmarker options settings

-- Global configurations
vim.g.mapleader = vim.keycode("<Space>") -- leader key
vim.g.markdown_recommended_style = 0 -- disable Markdown recommended style
-- disable providers
-- remove warnings in ':checkhealth'
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Editor options
vim.o.foldenable = true -- enable folding
vim.o.foldmethod = "marker"
vim.o.foldmarker = "{{{,}}}"

vim.o.clipboard = "unnamedplus" -- sync with the Linux clipboard
vim.o.fillchars = "eob: " -- hide tilde '~' for blank lines
vim.o.timeoutlen = 400 -- how long wait after each keystroke before aborting it
vim.o.undofile = true -- automatically save undo history
vim.o.cursorline = true -- highlight the current line
vim.o.ignorecase = true -- to search case insensitively
vim.o.smartcase = true -- when the search pattern is typed

-- Indenting
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.tabstop = 4 -- Number of spaces a tab represents
vim.o.softtabstop = 4 -- how many spaces moves right when you press <Tab>
vim.o.shiftwidth = 4 -- provide proper indentation to the code
vim.o.smartindent = true -- increase/reduce the indent where appropriate

-- UI options
vim.o.termguicolors = true -- use true color
vim.o.mouse = "a" -- enable the use of the mouse - all modes
vim.o.showmode = false -- show the mode you are on the last line
vim.o.laststatus = 3 -- to global display the status line
-- vim.o.showtabline = 2 -- not used - no tabline support
vim.o.number = true -- enable line numbers
vim.o.signcolumn = "yes" -- displaying the signs

vim.o.splitbelow = true -- create a vertical split and open
vim.o.splitright = true -- new file in the right-hand side of the split

-- require by persisted.nvim - enables saving and restoring
vim.o.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize"
