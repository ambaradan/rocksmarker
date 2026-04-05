-- lsp_utils.lua
local M = {}

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

  -- Show the notification
  vim.notify(message, vim.log.levels.INFO, { timeout = 5000, title = "Active LSP clients" })
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
  vim.bo[float_buf].filetype = "lsp_toggle"
  local float_win

  --- Function to update the floating window content with highlights
  local function update_float_content()
    local content = { "LSP Clients:", "" }
    vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, content)

    -- Create a namespace for highlights
    local ns = vim.api.nvim_create_namespace("lsp_status_highlight")

    -- Add content with highlights
    for i, name in ipairs(M._all_lsp_clients) do
      local status = current_client_names[name] and "attach" or "detach"
      local line_content = string.format("%s [%s]", name, status)
      vim.api.nvim_buf_set_lines(float_buf, i + 1, i + 1, false, { line_content })

      -- Apply highlight to "attach" or "detach"
      local status_start = #name + 2 -- Position of the status in the line
      local status_end = status_start + #status
      local hl_group = status == "attach" and "DiagnosticOk" or "DiagnosticWarn"

      vim.api.nvim_buf_set_extmark(float_buf, ns, i + 1, status_start, {
        end_col = status_end,
        hl_group = hl_group,
      })
    end
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
  local width = 30
  local height = math.min(#M._all_lsp_clients + 2, 20)
  local row = vim.o.lines - height - 5
  local col = vim.o.columns - 2

  float_win = vim.api.nvim_open_win(float_buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    anchor = "NE",
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

  -- Close the floating window when it loses focus
  local close_augroup = vim.api.nvim_create_augroup("CloseLspToggleOnFocusLost", { clear = true })
  vim.api.nvim_create_autocmd("WinLeave", {
    group = close_augroup,
    buffer = float_buf,
    callback = function()
      if vim.api.nvim_win_is_valid(float_win) then
        vim.api.nvim_win_close(float_win, true)
      end
    end,
  })

  -- Initial update of the floating window content
  update_float_content()

  vim.api.nvim_win_set_cursor(float_win, { 3, 0 })
end

--- Open a buffer with detailed information about LSP clients attached to the current buffer
--- @desc Opens a new buffer with detailed information about the LSP clients
--- currently attached to the current buffer, including formatted main capabilities.
--- @return nil
function M.show_lsp_details_buffer()
  -- Get the current buffer number
  local bufnr = vim.api.nvim_get_current_buf()

  -- Get all LSP clients attached to the current buffer
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if #clients == 0 then
    vim.notify("No LSP clients attached to the current buffer.", vim.log.levels.INFO)
    return
  end

  -- Create a new buffer for displaying LSP details
  local detail_buf = vim.api.nvim_create_buf(false, true)

  -- Create a namespace for highlights
  local ns = vim.api.nvim_create_namespace("lsp_details_highlight")

  -- Prepare the content for the buffer
  local content = {
    "LSP Clients Attached to Current Buffer:",
    "",
  }

  -- Insert content into the buffer
  vim.api.nvim_buf_set_lines(detail_buf, 0, -1, false, content)

  --- Function to add highlighted text using extmarks
  local function add_highlighted_text(line_num, text, hl_group)
    local line = vim.api.nvim_buf_get_lines(detail_buf, line_num, line_num + 1, false)[1]
    local start_col = #line
    vim.api.nvim_buf_set_text(detail_buf, line_num, start_col, line_num, start_col, { text })

    -- Apply highlight using extmark
    vim.api.nvim_buf_set_extmark(detail_buf, ns, line_num, start_col, {
      end_col = start_col + #text,
      hl_group = hl_group,
    })
  end

  -- Iterate over clients and add formatted content with highlights
  local current_line = #content + 1
  for _, client in ipairs(clients) do
    -- Add client name with highlight
    table.insert(content, string.format("• Name: "))
    vim.api.nvim_buf_set_lines(detail_buf, current_line, current_line, false, { content[#content] })
    add_highlighted_text(current_line - 1, client.name, "Title")
    current_line = current_line + 1

    -- Add client ID with highlight
    table.insert(content, string.format("• ID: "))
    vim.api.nvim_buf_set_lines(detail_buf, current_line, current_line, false, { content[#content] })
    add_highlighted_text(current_line - 1, tostring(client.id), "Number")
    current_line = current_line + 1

    -- Add filetypes with highlight
    table.insert(content, string.format("• Filetypes: "))
    vim.api.nvim_buf_set_lines(detail_buf, current_line, current_line, false, { content[#content] })
    add_highlighted_text(current_line - 1, table.concat(client.config.filetypes or {}, ", "), "String")
    current_line = current_line + 1

    -- Add root directory with highlight
    table.insert(content, string.format("• Root Directory: "))
    vim.api.nvim_buf_set_lines(detail_buf, current_line, current_line, false, { content[#content] })
    add_highlighted_text(current_line - 1, client.config.root_dir or "N/A", "Directory")
    current_line = current_line + 1

    -- Check and list main capabilities
    local capabilities = client.server_capabilities or {}

    -- Group capabilities by category
    local caps_by_category = {
      textDocument = {},
      workspace = {},
    }

    -- List of capabilities to check and their categories
    local caps_to_check = {
      { name = "textDocumentSync", category = "textDocument" },
      { name = "hoverProvider", category = "textDocument" },
      { name = "completionProvider", category = "textDocument" },
      { name = "definitionProvider", category = "textDocument" },
      { name = "referencesProvider", category = "textDocument" },
      { name = "documentSymbolProvider", category = "textDocument" },
      { name = "documentFormattingProvider", category = "textDocument" },
      { name = "documentRangeFormattingProvider", category = "textDocument" },
      { name = "renameProvider", category = "textDocument" },
      { name = "codeActionProvider", category = "textDocument" },
      { name = "workspaceSymbolProvider", category = "workspace" },
      { name = "diagnosticProvider", category = "workspace" },
    }

    -- Populate capabilities by category
    for _, cap in ipairs(caps_to_check) do
      if capabilities[cap.name] ~= nil then
        table.insert(caps_by_category[cap.category], cap.name)
      end
    end

    -- Add capabilities to content
    table.insert(content, "• Capabilities:")
    vim.api.nvim_buf_set_lines(detail_buf, current_line, current_line, false, { content[#content] })
    current_line = current_line + 1

    -- Text Document Capabilities
    if #caps_by_category.textDocument > 0 then
      table.insert(content, "  ○ Text Document:")
      vim.api.nvim_buf_set_lines(detail_buf, current_line, current_line, false, { content[#content] })
      current_line = current_line + 1
      for _, cap in ipairs(caps_by_category.textDocument) do
        table.insert(content, string.format("    - "))
        vim.api.nvim_buf_set_lines(detail_buf, current_line, current_line, false, { content[#content] })
        add_highlighted_text(current_line - 1, cap, "Function")
        current_line = current_line + 1
      end
    end

    -- Workspace Capabilities
    if #caps_by_category.workspace > 0 then
      table.insert(content, "  ○ Workspace:")
      vim.api.nvim_buf_set_lines(detail_buf, current_line, current_line, false, { content[#content] })
      current_line = current_line + 1
      for _, cap in ipairs(caps_by_category.workspace) do
        table.insert(content, string.format("    - "))
        vim.api.nvim_buf_set_lines(detail_buf, current_line, current_line, false, { content[#content] })
        add_highlighted_text(current_line - 1, cap, "Function")
        current_line = current_line + 1
      end
    end

    table.insert(content, "") -- Add an empty line for separation
    vim.api.nvim_buf_set_lines(detail_buf, current_line, current_line, false, { content[#content] })
    current_line = current_line + 1
  end

  -- Set buffer options
  vim.bo[detail_buf].filetype = "lsp_details"
  vim.bo[detail_buf].buftype = "nofile"
  vim.bo[detail_buf].bufhidden = "wipe"
  vim.bo[detail_buf].modifiable = false

  -- Open the buffer in a new window
  local win = vim.api.nvim_open_win(detail_buf, true, {
    split = "right",
  })

  -- Disable line numbers for this window
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
end

return M
