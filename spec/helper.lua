-- spec/helper.lua

local M = {}

-- Safely require a module
---@param module_name string The name of the module to load
---@return table The loaded module
function M.safe_require(module_name)
  local ok, module = pcall(require, module_name)
  if not ok then
    error("Failed to load module: " .. module_name)
  end
  return module
end

-- Set up a buffer with specific content
---@param content string The content to insert into the buffer
---@return number The buffer handle
function M.setup_buffer(content)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n"))
  vim.api.nvim_set_current_buf(buf)
  return buf
end

-- Clean up the environment after a test
function M.teardown()
  vim.cmd("%bdelete!")
end

-- Check if a plugin is available
---@param plugin_name string The name of the plugin to check
---@return boolean True if the plugin is available, false otherwise
function M.is_plugin_available(plugin_name)
  local ok, _ = pcall(require, plugin_name)
  return ok
end

-- Load a plugin configuration
---@param plugin_name string The name of the plugin configuration file (without the .lua extension)
function M.load_plugin_config(plugin_name)
  local ok, _ = pcall(require, "plugins." .. plugin_name)
  if not ok then
    error("Failed to load plugin config: " .. plugin_name)
  end
end

-- Simulate text insertion in insert mode
---@param text string The text to insert
function M.insert_text(text)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i" .. text, true, false, true), "n", true)
end

-- Verify the content of a buffer
---@param expected string The expected content
---@param bufnr number|nil The buffer number (defaults to current buffer)
function M.assert_buffer_content(expected, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local actual = table.concat(lines, "\n")
  assert(actual == expected, string.format("Expected:\n%s\nActual:\n%s", expected, actual))
end

return M
