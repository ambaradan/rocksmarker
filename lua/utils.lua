local M = {}

-- Buffer modification control function
---@desc Checks if a buffer has been modified.
---@param bufnr integer|nil Buffer number. If `nil`, defaults to the current buffer.
---@return boolean `true` if the buffer is modified, `false` otherwise.
function M.is_buffer_modified(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end
  local modified = false
  pcall(function()
    modified = vim.bo[bufnr].modified
  end)
  if not modified then
    pcall(function()
      modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
    end)
  end
  return modified or false
end

--- Saves all modified buffers in the current session
--- @desc Saves all modified buffers in Neovim.
--- This function iterates through all open buffers
--- and saves those that have been modified.
--- @return nil
function M.save_all_buffers()
  local modified_buffers = {}

  -- Find all modified buffers
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if M.is_buffer_modified(bufnr) then
      table.insert(modified_buffers, bufnr)
    end
  end

  -- If there are no modified buffers, notify the user
  if #modified_buffers == 0 then
    vim.notify("No modified buffers to save", vim.log.levels.INFO)
    return
  end

  -- Save all modified buffers and notify for each one
  for _, bufnr in ipairs(modified_buffers) do
    local buffer_name = vim.fn.bufname(bufnr)
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd("w!")
    end)
    vim.notify("Buffer '" .. vim.fn.fnamemodify(buffer_name, ":t") .. "' saved", vim.log.levels.INFO)
  end

  -- Notify completion of saving
  vim.notify(string.format("%d buffers saved", #modified_buffers), vim.log.levels.INFO)
end

--- Saves the current buffer in the Neovim session
--- If the buffer has unsaved changes, saves it and notifies the user.
--- Otherwise, notifies the user that there are no changes to save.
--- @return nil
function M.save_current_buffer()
  local buffer_name = vim.fn.bufname()
  if not buffer_name or buffer_name == "" then
    vim.notify("No valid buffer name found", vim.log.levels.ERROR)
    return
  end
  if M.is_buffer_modified() then
    vim.cmd("write!") -- Force save
    vim.notify("Buffer '" .. vim.fn.fnamemodify(buffer_name, ":t") .. "' saved", vim.log.levels.INFO)
  else
    vim.notify("No changes to " .. vim.fn.fnamemodify(buffer_name, ":t"), vim.log.levels.WARN)
  end
end

--- Creates a new buffer in the current session
--- If the current buffer has unsaved changes, prompts the user
--- to choose between saving and creating, creating without saving, or cancelling.
--- @return nil
function M.create_new_buffer()
  local current_buf = vim.api.nvim_get_current_buf()
  if M.is_buffer_modified(current_buf) then
    vim.ui.select({ "Save and Create", "Create Without Saving", "Cancel" }, {
      prompt = "Current buffer has unsaved changes:",
    }, function(choice)
      if choice == "Save and Create" then
        vim.cmd("write")
        vim.cmd("enew")
        vim.notify("Saved and created new buffer", vim.log.levels.INFO)
      elseif choice == "Create Without Saving" then
        vim.cmd("enew!")
        vim.notify("New buffer created without saving", vim.log.levels.WARN)
      else
        vim.notify("New buffer creation cancelled", vim.log.levels.INFO)
      end
    end)
  else
    vim.cmd("enew")
    vim.notify("New buffer created", vim.log.levels.INFO)
  end
end

--- Closes the current buffer in the Neovim session
--- If the buffer has unsaved changes, prompts the user to save before closing.
--- Otherwise, closes the buffer immediately.
--- @return nil
function M.close_current_buffer()
  local buffer_name = vim.fn.fnamemodify(vim.fn.bufname(), ":t")
  if M.is_buffer_modified() then
    vim.ui.select({ "Save and close", "Close without saving", "Cancel" }, {
      prompt = "Buffer '" .. buffer_name .. "' has unsaved changes. Choose an option:",
      format_item = function(item)
        return item
      end,
    }, function(choice)
      if choice == "Save and close" then
        M.save_current_buffer()
        vim.cmd("bdelete")
        vim.notify("Buffer '" .. buffer_name .. "' closed", vim.log.levels.INFO)
      elseif choice == "Close without saving" then
        vim.cmd("bdelete!")
        vim.notify("Buffer '" .. buffer_name .. "' closed without saving.", vim.log.levels.INFO)
      else
        vim.notify(
          "Action canceled. Buffer '" .. buffer_name .. "' remains open.",
          vim.log.levels.INFO,
          { timeout = 250 }
        )
      end
    end)
  else
    vim.cmd("bdelete")
    vim.notify("Buffer '" .. buffer_name .. "' closed", vim.log.levels.INFO)
  end
end

--- Closes all buffers in the current Neovim session
--- Prompts the user to choose between saving all, discarding changes,
--- or cancelling if any buffers have unsaved modifications.
--- @return nil
function M.close_all_buffers()
  local modified_bufs = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if M.is_buffer_modified(bufnr) then
      table.insert(modified_bufs, bufnr)
    end
  end
  if #modified_bufs > 0 then
    vim.ui.select({ "Yes (Save all)", "Yes (Discard changes)", "Cancel" }, {
      prompt = string.format("%d buffer(s) have unsaved changes. Close all?", #modified_bufs),
    }, function(choice)
      if choice == "Yes (Save all)" then
        M.save_all_buffers()
        vim.cmd("%bdelete!")
        vim.notify(
          string.format("Closed %d buffers with saving changes", #modified_bufs),
          vim.log.levels.INFO,
          { timeout = 2000 }
        )
      elseif choice == "Yes (Discard changes)" then
        vim.cmd("%bdelete!")
        vim.notify(
          string.format("Closed %d buffers forcefully", #modified_bufs),
          vim.log.levels.WARN,
          { timeout = 2000 }
        )
      else
        vim.notify("Close all buffers cancelled", vim.log.levels.INFO, { timeout = 1000 })
      end
    end)
  else
    vim.cmd("%bdelete")
    vim.notify("All buffers closed", vim.log.levels.INFO, { timeout = 1000 })
  end
end

--- Show all active LSP clients in a notification
--- @desc Displays a notification with all active LSP clients and their status.
--- @return nil
function M.show_lsp_clients_notification()
  local all_clients = vim.lsp.get_clients()
  local current_bufnr = vim.api.nvim_get_current_buf()
  local current_clients = vim.lsp.get_clients({ bufnr = current_bufnr })

  -- Create a set of current buffer client names for quick lookup
  local current_client_names = {}
  for _, client in ipairs(current_clients) do
    current_client_names[client.name] = true
  end

  if #all_clients == 0 then
    vim.notify("No active LSP clients.", vim.log.levels.INFO, { timeout = 3000, title = "Active LSP clients" })
    return
  end

  -- Prepare the content: list all unique LSP clients with status
  local unique_clients = {}
  for _, client in ipairs(all_clients) do
    if not vim.tbl_contains(unique_clients, client.name) then
      table.insert(unique_clients, client.name)
    end
  end
  table.sort(unique_clients)

  -- Prepare the notification message
  local message = ""
  for _, name in ipairs(unique_clients) do
    local status = current_client_names[name] and "✓" or "○"
    message = message .. string.format("%s %s\n", status, name)
  end

  -- Show the notification with a title and a longer timeout
  vim.notify(message, vim.log.levels.INFO, { timeout = 10000, title = "Active LSP clients" })
end

--- Toggle LSP clients interactively in a floating window
--- @desc Opens a floating window with a list of all LSP clients.
---       Allows enabling/disabling LSP clients for the current buffer.
--- @return nil
function M.toggle_lsp_clients()
  local bufnr = vim.api.nvim_get_current_buf()
  local all_clients = vim.lsp.get_clients()
  local current_clients = vim.lsp.get_clients({ bufnr = bufnr })

  -- Create a set of current buffer client names for quick lookup
  local current_client_names = {}
  for _, client in ipairs(current_clients) do
    current_client_names[client.name] = true
  end

  -- Prepare the content: list all unique LSP clients
  local unique_clients = {}
  for _, client in ipairs(all_clients) do
    if not vim.tbl_contains(unique_clients, client.name) then
      table.insert(unique_clients, client.name)
    end
  end

  -- Ensure we have a persistent list of all clients seen during the session
  M._all_lsp_clients = M._all_lsp_clients or {}
  for _, name in ipairs(unique_clients) do
    if not vim.tbl_contains(M._all_lsp_clients, name) then
      table.insert(M._all_lsp_clients, name)
    end
  end

  table.sort(M._all_lsp_clients)

  if #M._all_lsp_clients == 0 then
    vim.notify("No LSP clients available.", vim.log.levels.INFO)
    return
  end

  -- Create a buffer for the floating window
  local float_buf = vim.api.nvim_create_buf(false, true)
  local float_win

  -- Function to update the floating window content
  local function update_float_content()
    local content = { "LSP Clients:", "" }
    for _, name in ipairs(M._all_lsp_clients) do
      local status = current_client_names[name] and "attach" or "detach"
      table.insert(content, string.format("%s [%s]", name, status))
    end
    vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, content)
  end

  -- Function to toggle the selected LSP client
  local function toggle_client(line)
    -- Extract client name from the line
    local name = line:match("^(.+) %[.+%]")
    if not name then
      return
    end

    local is_attached = current_client_names[name] ~= nil

    if is_attached then
      vim.cmd(string.format("lsp disable %s", name))
      vim.notify(string.format("Disabled LSP client: %s", name), vim.log.levels.INFO)
    else
      vim.cmd(string.format("lsp enable %s", name))
      vim.notify(string.format("Enabled LSP client: %s", name), vim.log.levels.INFO)
    end

    -- Update the current clients list and refresh the window
    current_clients = vim.lsp.get_clients({ bufnr = bufnr })
    current_client_names = {}
    for _, client in ipairs(current_clients) do
      current_client_names[client.name] = true
    end
    update_float_content()
  end

  -- Create the floating window
  local width = 50
  local height = math.min(#M._all_lsp_clients + 2, 20)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  float_win = vim.api.nvim_open_win(float_buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = "Toggle LSP Clients",
    title_pos = "center",
  })

  -- Set keymaps for the floating window
  vim.api.nvim_buf_set_keymap(float_buf, "n", "<CR>", "", {
    noremap = true,
    silent = true,
    callback = function()
      local line = vim.api.nvim_get_current_line()
      toggle_client(line)
    end,
  })

  vim.api.nvim_buf_set_keymap(float_buf, "n", "q", "", {
    noremap = true,
    silent = true,
    callback = function()
      vim.api.nvim_win_close(float_win, true)
    end,
  })

  -- Initial update of the floating window content
  update_float_content()
end

-- Initialize the list of all LSP clients
M._all_lsp_clients = M._all_lsp_clients or {}

return M
