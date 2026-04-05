-- commands.lua
-- Module for setting up Neovim autocommands and utility functions.

local augroup = vim.api.nvim_create_augroup("RocksmarkerSet", { clear = true })

-- Show LSP progress with a spinner in notifications
vim.api.nvim_create_autocmd("LspProgress", {
  group = augroup,
  callback = function(args)
    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    local ev = args.data
    vim.notify(vim.lsp.status(), vim.log.levels.INFO, {
      id = "lsp_progress",
      title = "LSP Progress",
      opts = function(notif)
        notif.icon = ev.params.value.kind == "end" and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

-- Reload files when focus is regained or terminal interactions occur
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup,
  desc = "Reload files when focus is regained or terminal interactions occur",
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Allow closing specific utility buffers with 'q' key
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
    "lsp_toggle",
    "lsp_details",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Highlight text after yanking to provide visual feedback
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  desc = "Highlight text after yanking to provide visual feedback",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Open help documents in a vertical split and equalize window sizes
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

-- Toggle cursorline based on filetype (disable for Markdown)
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  desc = "Toggle cursorline based on filetype (disable for Markdown)",
  callback = function()
    local current_filetype = vim.bo.filetype
    vim.wo.cursorline = current_filetype ~= "markdown"
  end,
})

-- Disable spell check for 'lsp_details' buffers
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "lsp_details",
  desc = "Disable spell check for LSP details buffer",
  callback = function(event)
    vim.schedule(function()
      -- Get all windows displaying this buffer
      local buf_info = vim.fn.getbufinfo(event.buf)
      if buf_info and buf_info[1] and buf_info[1].windows then
        for _, win_id in ipairs(buf_info[1].windows) do
          -- Disable spell check for each window displaying the buffer
          vim.api.nvim_set_option_value("spell", false, { win = win_id })
        end
      end
    end)
  end,
})
