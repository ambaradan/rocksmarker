-- Rocksmarker mappings

local utils = require("utils")

local snacks_ok, snacks = pcall(require, "snacks")
if not snacks_ok then
  return
end

local map = snacks
    .keymap --[[@cast -?]]
    .set
-- Buffer mappings
-- Save buffer in Insert and Normal modes
map({ "i", "n" }, "<C-s>", function()
  utils.save_current_buffer()
end, { desc = "save buffer" })

map({ "i", "n" }, "<C-a>", function()
  utils.save_all_buffers()
end, { desc = "save all buffer" })

-- Create a new empty buffer
map("n", "<leader>b", function()
  utils.create_new_buffer()
end, { desc = "new buffer" })

map("n", "<leader>x", function()
  utils.close_current_buffer()
end, { desc = "close buffer" })

map("n", "<leader>X", function()
  utils.close_all_buffers()
end, { desc = "close all buffers" })

-- Editor mappings
-- Remap <leader>q to quit the current buffer/window
map("n", "<leader>q", "<cmd>q<cr>", { desc = "quit editor" })

map("n", "<C-e>", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "explorer",
        title = "File Manager",
      })
end, { desc = "open file" })

map("n", "<C-f>", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "files",
        layout = { preset = "vscode" },
        title = "Open file",
      })
end, { desc = "open file" })

map("n", "<F8>", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "lsp_symbols",
        title = "Markdown Headers",
        layout = { layout = { position = "right", width = 0.3 }, preview = false },
      })
end, {
  ft = "markdown",
  desc = "Markdown Header",
})

map("n", "<F6>", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "diagnostics_buffer",
        title = "Markdown Diagnostics",
        layout = { layout = { position = "right", width = 0.4 }, preview = false },
      })
end, {
  ft = "markdown",
  desc = "Markdown Diagnostics",
})

-- Remap <Esc> to clear search highlights
-- Useful after searching to remove highlight remnants
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "clear highlights" })

-- conform - manual formatting
map("n", "<leader>F", function()
  require("conform").format({ lsp_fallback = true })
end, { desc = "format buffer" })

-- Copy selected text to system clipboard in visual mode
map("v", "<C-c>", '"+y', { desc = "Copy selected text to system clipboard" })

-- Cut (delete and copy) selected text to system clipboard in visual mode
map("v", "<C-x>", '"+d', { desc = "Cut selected text to system clipboard" })

-- Copy entire line to system clipboard
map("n", "<S-c>", function()
  vim.cmd('normal! ^vg_"+y') -- Yank to system clipboard
end, { desc = "Copy entire line to system clipboard" })

-- Cut entire line to system clipboard
map("n", "<S-x>", function()
  vim.cmd('normal! ^vg_"+d') -- Cut to system clipboard
end, { desc = "cut entire line to system clipboard" })

-- Paste over selected text in both visual and normal mode
map({ "v", "n" }, "<C-v>", '"+p', { desc = "paste over selected text" })

-- Paste from system clipboard in insert mode
map("i", "<C-v>", "<C-r>+", { desc = "paste from system clipboard" })

-- Paste in visual mode without overwriting the current register
map("v", "<CS-v>", '"_dP', { desc = "paste without overwriting register" })

-- Remap the 'y' and 'p' commands in visual mode to preserve the cursor position
map("x", "y", "y`]", { noremap = true, silent = true, desc = "yank and preserve cursor position" })
map("x", "p", "p`]", { noremap = true, silent = true, desc = "put and preserve cursor position" })

-- Remap the 'J' and 'K' commands in visual mode
-- to move the selected block up or down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "move block up" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "move block down" })

-- bufferline.nvim mappings
map("n", "<leader>bp", ":BufferLinePick<CR>", { desc = "buffer line pick" })
map("n", "<leader>bc", ":BufferLinePickClose<CR>", { desc = "buffer line pick close" })
map("n", "<TAB>", ":BufferLineCycleNext<CR>", { desc = "buffer line cycle next" })
map("n", "<S-TAB>", ":BufferLineCyclePrev<CR>", { desc = "buffer line cycle prev" })

-- Buffer list
map("n", "<leader>fb", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "buffers",
        layout = { preset = "vscode" },
        title = "Buffer list",
      })
end, { desc = "Buffer list" })

-- Recent files (recently opened)
map("n", "<leader>fo", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "recent",
        title = "Recent Files",
        layout = { preset = "vscode" },
      })
end, { desc = "Recently opened files" })

-- Undo (undo operations on file)
map("n", "<leader>fu", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "undo",
        title = "Undo operations",
        layout = { preset = "telescope" },
      })
end, { desc = "Undo operations" })

-- Toggle global diagnostics
map("n", "<leader>dw", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "diagnostics",
        title = "Workspace Diagnostics",
        layout = { preset = "ivy" },
      })
end, { desc = "toggle global diagnostics" })

-- Toggle buffer diagnostics
map("n", "<leader>db", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "diagnostics_buffer",
        title = "Buffer Diagnostics",
        layout = { preset = "ivy" },
      })
end, { desc = "toggle buffer diagnostics" })

-- Session mappings - persisted.nvim
-- Persisted - Get session file name and session name
local function get_session_names()
  local session_file_name = vim.fn.fnamemodify(vim.g.persisted_loaded_session, ":t")
  local clean_session_name = session_file_name:match(".*%%(.*)") or session_file_name
  return session_file_name, clean_session_name
end

-- Select session
map("n", "<A-s>", function()
  require("persisted").select()
end, { desc = "session selection" })

-- Load last session
map("n", "<A-l>", function()
  require("persisted").load({ last = true })
  local _, clean_session_name = get_session_names()
  vim.notify("Loading: " .. clean_session_name, vim.log.levels.INFO)
end, { desc = "load last session" })

-- Save current session
map("n", "<leader>ss", function()
  require("persisted").save()
  local _, clean_session_name = get_session_names()
  vim.notify("Session '" .. clean_session_name .. "' saved", vim.log.levels.INFO)
end, { desc = "save current session" })

-- Load last session (alternative mapping)
map("n", "<leader>sl", function()
  require("persisted").load({ last = true })
  local _, clean_session_name = get_session_names()
  vim.notify("Loading: " .. clean_session_name, vim.log.levels.INFO)
end, { desc = "load last session" })

-- Stop current session
map("n", "<leader>st", function()
  require("persisted").stop()
  local _, clean_session_name = get_session_names()
  vim.notify(clean_session_name .. " stopped", vim.log.levels.INFO)
end, { desc = "stop current session" })

-- Delete sessions
map("n", "<leader>sd", function()
  require("persisted").delete()
end, { desc = "delete sessions" })

-- grug-far - search and replace
map("n", "<leader>R", function()
  require("grug-far").open()
end, { desc = "search and replace" })

-- Search current word globally
map({ "n", "x" }, "<leader>rw", function()
  require("grug-far").open({
    prefills = { search = vim.fn.expand("<cword>") },
  })
end, { desc = "search current word" })

-- Search current word in current file
map({ "n", "x" }, "<leader>rp", function()
  require("grug-far").open({
    prefills = {
      paths = vim.fn.expand("%"),
      search = vim.fn.expand("<cword>"),
    },
  })
end, { desc = "search word on current file" })

-- Git mappings
-- Open Neogit for workspace
map("n", "<leader>gm", function()
  require("neogit").open()
end, { desc = "git manager (workspace)" })

-- Open Neogit for current buffer's directory
map("n", "<leader>gM", function()
  require("neogit").open({
    cwd = vim.fn.expand("%:p:h"), -- Current buffer's directory
  })
end, { desc = "git manager (buffer)" })

-- Git commits log
map("n", "<leader>gl", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "git_log",
        title = "Git commits log",
        layout = { preset = "telescope" },
      })
end, { desc = "git commits log" })

-- Git commits for current buffer
map("n", "<leader>gb", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "git_log_file",
        title = "Git buffer log",
        layout = { preset = "telescope" },
      })
end, { desc = "git buffer log" })

-- Git diff for current buffer
map("n", "<leader>gd", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "git_diff",
        title = "Git buffer diff",
        layout = { preset = "telescope" },
      })
end, { desc = "git buffer diff" })

-- Git status
map("n", "<leader>gs", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "git_status",
        title = "Git status",
        layout = { preset = "telescope" },
      })
end, { desc = "git status" })

-- Help picker
map("n", "<leader>hl", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "help",
        title = "Help search",
        layout = { preset = "dropdown" },
      })
end, { desc = "help search" })

-- Neovim highlights search``
map("n", "<F7>", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "highlights",
        title = "Highlights search",
        layout = { preset = "ivy" },
      })
end, { desc = "highlights search" })

-- Toggle terminal mappings
map({ "n", "i", "t" }, "<a-t>", function()
  ---@diagnostic disable-next-line: need-check-nil
  snacks.terminal()
end, { desc = "Toggle Terminal" })

-- Toggle zen mode mappings
map("n", "<a-z>", function()
  ---@diagnostic disable-next-line: need-check-nil
  snacks.zen.zoom()
end, { desc = "zen mode" })

-- Mapping to exit terminal mode using Esc
map("t", "jk", [[<C-\><C-n>]], { desc = "Exit Terminal Mode" })

-- Utility function to get current buffer and active LSP clients
local function get_current_buffer_and_clients()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  return bufnr, clients
end

-- Set keymap for buffers with any LSP that supports code actions
map("n", "<leader>ca", vim.lsp.buf.code_action, {
  lsp = { method = "textDocument/codeAction" },
  desc = "Code Action",
})

-- Show hover documentation
map("n", "K", vim.lsp.buf.hover, {
  lsp = { method = "textDocument/hover" },
  desc = "Hover Documentation",
})

-- Go to definition
map("n", "gd", vim.lsp.buf.definition, {
  lsp = { method = "textDocument/definition" },
  desc = "goto definitions",
})

-- Open LSP document symbols picker
map("n", "<leader>ls", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "lsp_symbols",
        title = "Lsp Symbols",
        layout = { preset = "ivy" },
      })
end, {
  lsp = { method = "textDocument/documentSymbol" },
  desc = "document symbols",
})

-- Show signature documentation
map("n", "<C-k>", vim.lsp.buf.signature_help, {
  lsp = { method = "textDocument/signature_help" },
  desc = "signature documentation",
})

-- Rename symbol
map("n", "<leader>lR", vim.lsp.buf.rename, {
  lsp = { method = "textDocument/rename" },
  desc = "lsp rename",
})

-- Open LSP references picker
map("n", "<leader>lr", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "lsp_references",
        title = "Lsp References",
        layout = { preset = "ivy" },
      })
end, {
  lsp = { method = "textDocument/references" },
  desc = "lsp references",
})

-- Open LSP implementations picker
map("n", "<leader>lI", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "lsp_implementations",
        title = "Lsp Implementations",
        layout = { preset = "ivy" },
      })
end, {
  lsp = { method = "textDocument/implementation" },
  desc = "goto implementation",
})

-- Go to type definition
map("n", "<leader>lD", vim.lsp.buf.definition, {
  lsp = { method = "textDocument/definition" },
  desc = "type definition",
})

-- Open LSP workspace symbols picker
map("n", "<leader>lw", function()
  snacks
      .picker --[[@cast -?]]
      .pick({
        source = "lsp_workspace_symbols",
        title = "Lsp workspace symbols",
        layout = { preset = "ivy" },
      })
end, {
  lsp = { method = "textDocument/workspace_symbol" },
  desc = "workspace symbol",
})

map("n", "<leader>lh", function()
  local bufnr, clients = get_current_buffer_and_clients()

  for _, client in ipairs(clients) do
    if
        client
        .server_capabilities --[[@cast -?]]
        .documentHighlightProvider
    then
      local hl_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

      -- Highlight references on cursor hold
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = hl_group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })

      -- Clear highlights when the cursor moves
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = hl_group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })

      -- Clean up highlights and autocommands when the LSP detaches
      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
        callback = function(detach_event)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = detach_event.buf })
        end,
      })

      vim.notify("Document Highlight enabled", vim.log.levels.INFO)
      return
    end
  end
  vim.notify("No LSP with document highlight support found", vim.log.levels.WARN)
end, { desc = "toggle document highlight" })

map("n", "<leader>li", function()
  local bufnr, clients = get_current_buffer_and_clients()

  for _, client in ipairs(clients) do
    if
        client
        .server_capabilities --[[@cast -?]]
        .inlayHintProvider
    then
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      local status = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }) and "enabled" or "disabled"
      vim.notify("Inlay Hints " .. status, vim.log.levels.INFO)
      return
    end
  end
  vim.notify("No LSP with inlay hint support found", vim.log.levels.WARN)
end, { desc = "Toggle Inlay Hints" })

--- Toggle diagnostic virtual text on or off.
--- @desc Toggles diagnostic virtual text in Neovim.
--- @params None
local function toggle_diagnostic_virtual_text()
  local current_config = vim.diagnostic.config() or { virtual_text = false }
  local new_virtual_text = not current_config.virtual_text
  vim.diagnostic.config({ virtual_text = new_virtual_text })
  vim.notify("Diagnostic virtual text: " .. (new_virtual_text and "ON" or "OFF"), vim.log.levels.INFO)
end

-- Keymap to toggle diagnostic virtual text
map("n", "<leader>dd", toggle_diagnostic_virtual_text, { desc = "toggle diagnostic virtual text" })

-- Function to check if an LSP client is active
local function is_lsp_active(client_name)
  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.name == client_name then
      return true
    end
  end
  return false
end

-- Function to enable `harper_ls`
local function enable_harper_ls()
  if not is_lsp_active("harper_ls") then
    vim.cmd("LspStart harper_ls")
    vim.notify("harper_ls enabled", vim.log.levels.INFO)
  else
    vim.notify("harper_ls is already active", vim.log.levels.WARN)
  end
end

-- Function to disable `harper_ls`
local function disable_harper_ls()
  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.name == "harper_ls" then
      vim.lsp.stop_client(client.id, true)
      vim.notify("harper_ls disabled", vim.log.levels.INFO)
      return
    end
  end
  vim.notify("harper_ls is not active", vim.log.levels.WARN)
end

-- Function to toggle (enable/disable) `harper_ls`
local function toggle_harper_ls()
  if is_lsp_active("harper_ls") then
    disable_harper_ls()
  else
    enable_harper_ls()
  end
end

-- -- Create custom commands to enable, disable, and toggle harper_ls
vim.api.nvim_create_user_command("HarperEnable", enable_harper_ls, {})
vim.api.nvim_create_user_command("HarperDisable", disable_harper_ls, {})
vim.api.nvim_create_user_command("HarperToggle", toggle_harper_ls, {})

-- (Optional) Key mapping to toggle harper_ls
map("n", "<leader>th", toggle_harper_ls, { desc = "Toggle harper_ls" })
