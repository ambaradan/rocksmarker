local augroup = vim.api.nvim_create_augroup("RocksmarkerSet", { clear = true })

vim.api.nvim_create_autocmd("LspProgress", {
  group = augroup,
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(vim.lsp.status(), "info", {
      id = "lsp_progress",
      title = "LSP Progress",
      opts = function(notif)
        notif.icon = ev.data.params.value.kind == "end" and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

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
    "grug-far",
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

-- Re-enable cursorline when leaving markdown
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  callback = function()
    -- Get the filetype of the buffer that was just entered
    local current_filetype = vim.bo.filetype

    -- Disable cursorline if it's a markdown buffer, otherwise enable it
    if current_filetype == "markdown" then
      vim.wo.cursorline = false
    else
      vim.wo.cursorline = true
    end
  end,
})
