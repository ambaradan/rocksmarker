local o = vim.o

vim.g.mapleader = " "

vim.g.markdown_recommended_style = 0
-- enable folding
vim.opt.foldmethod = "marker"
vim.opt.foldmarker = "{{{,}}}"
vim.opt.foldenable = true
-- options for 'status' and 'tab' lines
-- to global display the status line
o.laststatus = 3
-- not used - no tabline support
-- o.showtabline = 2
-- enable true color 24-bit RGB
o.termguicolors = true
-- show the mode you are on the last line
o.showmode = false
-- compatibility with the two Linux registers
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })
-- require by persisted.nvim
o.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize"

-- Indenting
o.expandtab = true
o.shiftwidth = 4
o.smartindent = true
o.tabstop = 4
o.softtabstop = 4
-- hide tilde '~' for blank lines
vim.opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
-- enable the use of the mouse - all modes
o.mouse = "a"

o.number = true

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true
o.cursorline = true

-- disable providers - remove warnings in ':checkhealth'
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
