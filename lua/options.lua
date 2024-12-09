local o = vim.o

vim.g.mapleader = " "

-- options for 'status' and 'tab' lines
o.laststatus = 2
o.showtabline = 2

o.termguicolors = true
o.showmode = false
o.clipboard = "unnamedplus"

-- require by persisted.nvim
o.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize"

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

vim.opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

o.number = true

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true
o.cursorline = true
