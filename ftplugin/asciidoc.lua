-- asciidoc.lua
-- Neovim ftplugin for AsciiDoc files
vim.bo.commentstring = "// %s"
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.expandtab = true
vim.wo.number = false

vim.wo.spell = true
vim.bo.spelllang = "en,it"
vim.bo.spellfile = vim.fn.stdpath("config") .. "/spell/exceptions.utf-8.add"
