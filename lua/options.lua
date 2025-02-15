local o = vim.o --set local variable

vim.g.mapleader = vim.keycode("<Space>") -- leader key
vim.g.markdown_recommended_style = 0 -- disable Markdown recommended style

-- enable folding
o.foldmethod = "marker"
o.foldmarker = "{{{,}}}"
o.foldenable = true

-- options for 'status' and 'tab' lines
o.laststatus = 3 -- to global display the status line
-- o.showtabline = 2 -- not used - no tabline support

o.termguicolors = true -- enable true color 24-bit RGB
o.showmode = false -- show the mode you are on the last line

-- compatibility with the two Linux registers
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })
-- require by persisted.nvim
o.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize"

-- Indenting
o.expandtab = true -- Convert tabs to spaces
o.shiftwidth = 4 -- provide proper indentation to the code
-- o.smartindent = true
o.tabstop = 4 -- Number of spaces a tab represents
o.softtabstop = 4 -- how many spaces moves right when you press <Tab>

vim.opt.fillchars = { eob = " " } -- hide tilde '~' for blank lines
o.ignorecase = true -- to search case insensitively
o.smartcase = true -- when the search pattern is typed

o.mouse = "a" -- enable the use of the mouse - all modes

o.number = true -- Enable line numbers

o.signcolumn = "yes" -- displaying the signs

o.splitbelow = true -- create a vertical split and open
o.splitright = true -- new file in the right-hand side of the split

o.timeoutlen = 400 -- how long wait after each keystroke before aborting it
o.undofile = true -- automatically save undo history
o.cursorline = true -- highlight the current line

-- disable providers - remove warnings in ':checkhealth'
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
