-- Rocksmarker mappings
local editor = require("utils.editor")

-- Buffer mappings
-- Save buffer in Insert and Normal modes
editor.remap({ "i", "n" }, "<C-s>", function()
  editor.save_current_buffer()
end, editor.make_opt("Save buffer"))

-- Create a new empty buffer
editor.remap("n", "<leader>b", function()
  editor.create_new_buffer()
end, editor.make_opt("new buffer"))

editor.remap("n", "<leader>x", function()
  require("snacks").bufdelete()
end, editor.make_opt("close buffer"))

editor.remap("n", "<leader>X", function()
  require("snacks").bufdelete.all()
end, editor.make_opt("close all buffers"))

-- Editor mappings
-- Remap <leader>q to quit the current buffer/window
editor.remap("n", "<leader>q", "<cmd>q<cr>", editor.make_opt("quit editor"))

editor.remap("n", "<C-o>", function()
  require("snacks").picker.pick({
    source = "explorer",
    layout = { layout = { position = "right" } },
    title = "File Manager",
  })
end, editor.make_opt("open file"))

editor.remap("n", "<C-f>", function()
  require("snacks").picker.pick({
    source = "files",
    layout = { layout = { position = "top" } },
    title = "Open file",
  })
end, editor.make_opt("open file"))

-- Remap <Esc> to clear search highlights
-- Useful after searching to remove highlight remnants
editor.remap("n", "<Esc>", "<cmd>noh<CR>", editor.make_opt("clear highlights"))

-- conform - manual formatting
editor.remap("n", "<leader>F", function()
  require("conform").format({ lsp_fallback = true })
end, editor.make_opt("format buffer"))

-- Copy selected text to system clipboard in visual mode
editor.remap("v", "<C-c>", '"+y', editor.make_opt("Copy selected text to system clipboard"))

-- Cut (delete and copy) selected text to system clipboard in visual mode
editor.remap("v", "<C-x>", '"+d', editor.make_opt("Cut selected text to system clipboard"))

-- Copy entire line to system clipboard
editor.remap("n", "<S-c>", function()
  vim.cmd('normal! ^vg_"+y') -- Yank to system clipboard
end, editor.make_opt("Copy entire line to system clipboard"))

-- Cut entire line to system clipboard
editor.remap("n", "<S-x>", function()
  vim.cmd('normal! ^vg_"+d') -- Cut to system clipboard
end, editor.make_opt("Cut entire line to system clipboard"))

-- Paste over selected text in both visual and normal mode
editor.remap({ "v", "n" }, "<C-v>", '"+p', editor.make_opt("Paste over selected text"))

-- Paste from system clipboard in insert mode
editor.remap("i", "<C-v>", "<C-r>+", editor.make_opt("Paste from system clipboard"))

-- Paste in visual mode without overwriting the current register
editor.remap("v", "<CS-v>", '"_dP', editor.make_opt("Paste without overwriting register"))

-- Remap the 'y' and 'p' commands in visual mode
-- to preserve the cursor position
vim.cmd("vnoremap <silent> y y`]")
vim.cmd("vnoremap <silent> p p`]")

-- Remap the 'J' and 'K' commands in visual mode
-- to move the selected block up or down
editor.remap("v", "J", ":m '>+1<CR>gv=gv", editor.make_opt("move block up"))
editor.remap("v", "K", ":m '<-2<CR>gv=gv", editor.make_opt("move block down"))

-- Diagnostics toggle
editor.remap("n", "<leader>dd", function()
  editor.toggle_diagnostic_virtual_text()
end, editor.make_opt("Toggle Diagnostics"))

-- neo-tree.nvim mappings
-- Toggle Neo-tree File Explorer in a floating window
-- editor.remap("n", ".", function()
--   require("neo-tree.command").execute({ toggle = true, position = "float", dir = vim.fn.getcwd() })
-- end, editor.make_opt("Neo-tree File Explorer (float)"))

-- Toggle Neo-tree File Explorer in a right window
-- editor.remap("n", "<C-n>", function()
--   require("neo-tree.command").execute({ toggle = true, position = "right", source = "filesystem" })
-- end, editor.make_opt("Neo-tree File Explorer (right)"))

-- Reveal current file in Neo-tree filesystem
-- editor.remap("n", "<leader>fr", function()
--   require("neo-tree.command").execute({
--     reveal = true,
--     toggle = true,
--     position = "float",
--     source = "filesystem",
--   })
-- end, editor.make_opt("Reveal File in workspace"))

-- bufferline.nvim mappings
editor.remap("n", "<leader>bp", ":BufferLinePick<CR>", editor.make_opt("Buffer Line Pick"))
editor.remap("n", "<leader>bc", ":BufferLinePickClose<CR>", editor.make_opt("Buffer Line Pick Close"))
editor.remap("n", "<TAB>", ":BufferLineCycleNext<CR>", editor.make_opt("Buffer Line Cycle Next"))
editor.remap("n", "<S-TAB>", ":BufferLineCyclePrev<CR>", editor.make_opt("Buffer Line Cycle Prev"))

-- Buffer list
editor.remap("n", "<leader>fb", function()
  require("snacks").picker.pick({
    source = "buffers",
    layout = { preset = "bottom" },
    title = "Buffer list",
  })
end, editor.make_opt("Buffer list"))

-- Recent files (recently opened)
editor.remap("n", "<leader>fo", function()
  require("snacks").picker.pick({
    source = "recent",
    title = "Recent Files",
  })
end, editor.make_opt("Recently opened files"))

-- Undo (undo operations on file)
editor.remap("n", "<leader>fu", function()
  require("snacks").picker.pick({
    source = "undo",
    title = "Undo operations",
  })
end, editor.make_opt("Undo operations"))

-- Toggle global diagnostics
editor.remap("n", "<leader>dw", function()
  require("snacks").picker.pick({
    source = "diagnostics",
    title = "Workspace Diagnostics",
  })
end, editor.make_opt("toggle global diagnostics"))

-- Toggle buffer diagnostics
editor.remap("n", "<leader>db", function()
  require("snacks").picker.pick({
    source = "diagnostics_buffer",
    title = "Buffer Diagnostics",
    layout = { layout = { position = "bottom" } },
  })
end, editor.make_opt("toggle buffer diagnostics"))

-- session mappings - persisted.nvim
-- Import the get_session_names function
local get_session_names = editor.get_session_names

-- Select session
editor.remap("n", "<A-s>", function()
  require("persisted").select()
end, editor.make_opt("Session Selection"))

-- Load last session
editor.remap("n", "<A-l>", function()
  require("persisted").load({ last = true })
  local _, clean_session_name = get_session_names()
  vim.notify("Loading: " .. clean_session_name, vim.log.levels.INFO)
end, editor.make_opt("load last session"))

-- Save current session
editor.remap("n", "<leader>ss", function()
  require("persisted").save()
  local _, clean_session_name = get_session_names()
  vim.notify("Session '" .. clean_session_name .. "' saved", vim.log.levels.INFO)
end, editor.make_opt("Save Current Session"))

-- Load last session (alternative mapping)
editor.remap("n", "<leader>sl", function()
  require("persisted").load({ last = true })
  local _, clean_session_name = get_session_names()
  vim.notify("Loading: " .. clean_session_name, vim.log.levels.INFO)
end, editor.make_opt("Load Last Session"))

-- Stop current session
editor.remap("n", "<leader>st", function()
  require("persisted").stop()
  local _, clean_session_name = get_session_names()
  vim.notify(clean_session_name .. " stopped", vim.log.levels.INFO)
end, editor.make_opt("Stop Current Session"))

-- search and replace
editor.remap("n", "<leader>R", function()
  require("grug-far").open()
end, editor.make_opt("Search and replace"))

-- Search current word globally
editor.remap({ "n", "x" }, "<leader>rw", function()
  require("grug-far").open({
    prefills = { search = vim.fn.expand("<cword>") },
  })
end, editor.make_opt("Search current word"))

-- Search current word in current file
editor.remap({ "n", "x" }, "<leader>rp", function()
  require("grug-far").open({
    prefills = {
      paths = vim.fn.expand("%"),
      search = vim.fn.expand("<cword>"),
    },
  })
end, editor.make_opt("Search word on current file"))

-- Git mappings
-- Git commits log
editor.remap("n", "<leader>gl", function()
  require("snacks").picker.pick({
    source = "git_log",
    title = "Git commits log",
  })
end, editor.make_opt("git commits log"))

-- Git commits for current buffer
editor.remap("n", "<leader>gb", function()
  require("snacks").picker.pick({
    source = "git_log_file",
    title = "Git buffer log",
  })
end, editor.make_opt("git buffer log"))

editor.remap("n", "<leader>gd", function()
  require("snacks").picker.pick({
    source = "git_diff",
    title = "Git buffer diff",
  })
end, editor.make_opt("git buffer diff"))

editor.remap("n", "<leader>gs", function()
  require("snacks").picker.pick({
    source = "git_status",
    title = "Git status",
  })
end, editor.make_opt("git status"))

editor.remap("n", "<leader>hl", function()
  require("snacks").picker.pick({
    source = "help",
    title = "Help search",
    layout = { layout = { position = "bottom" } },
  })
end, editor.make_opt("help search"))

editor.remap("n", "<F7>", function()
  require("snacks").picker.pick({
    source = "highlights",
    title = "Highlights search",
    layout = { layout = { position = "bottom" } },
  })
end, editor.make_opt("highlights search"))

-- Toggle terminal mappings
editor.remap({ "n", "i", "t" }, "<a-t>", function()
  require("snacks").terminal()
end, editor.make_opt("Toggle Terminal"))

-- Toggle zen mode mappings
editor.remap({ "n", "i", "t" }, "<a-z>", function()
  require("snacks").zen.zoom()
end, editor.make_opt("zen mode"))

-- Mapping to exit terminal mode using Esc
editor.remap("t", "jk", [[<C-\><C-n>]], editor.make_opt("Exit Terminal Mode"))
