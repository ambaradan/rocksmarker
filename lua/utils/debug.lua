-- lua/utils/debug.lua
-- Debug and logging utilities for Neovim.
-- This module provides functions for logging messages, tables, and execution times.

local M = {}

-- Import configuration or use defaults
local config = require("config")
  or {
    config = {
      debug = false,
      log_file_path = vim.fn.stdpath("data") .. "/rocksmarker_debug.log",
    },
  }

--- Writes a message to a log file with a timestamp.
-- @param message (string) The message to log.
function M.log_to_file(message)
  local log_file = config.config.log_file_path
  local timestamped_message = os.date("%Y-%m-%d %H:%M:%S") .. " - " .. message .. "\n"

  -- Open the file in append mode
  vim.loop.fs_open(log_file, "a", 438, function(open_err, fd)
    if open_err then
      vim.notify("Failed to open log file: " .. log_file .. " - Error: " .. open_err, vim.log.levels.ERROR)
      return
    end

    -- Write the message to the file
    vim.loop.fs_write(fd, timestamped_message, -1, function(write_err)
      if write_err then
        vim.notify("Failed to write to log file: " .. write_err, vim.log.levels.ERROR)
      end
      -- Close the file
      vim.loop.fs_close(fd)
    end)
  end)
end

--- Logs a table in a readable format (useful for debugging complex structures).
-- @param tbl (table) The table to log.
-- @param indent (integer|nil) Indentation level (default: 0).
-- @return (string) The string representation of the table.
function M.log_table(tbl, indent)
  indent = indent or 0
  local indent_str = string.rep("  ", indent)
  local log_str = ""

  for k, v in pairs(tbl) do
    if type(v) == "table" then
      log_str = log_str .. string.format("%s%s:\n", indent_str, tostring(k))
      log_str = log_str .. M.log_table(v, indent + 1)
    else
      log_str = log_str .. string.format("%s%s: %s\n", indent_str, tostring(k), tostring(v))
    end
  end

  M.log_debug(log_str)
  return log_str
end

--- Executes a function and logs its execution time only if it exceeds a threshold.
-- @param func (function) The function to execute.
-- @param threshold (number|nil) Minimum execution time to log (default: 0.0001 seconds).
-- @param ... (any) Arguments to pass to the function.
-- @return (any) The return values of the executed function.
function M.debug_execution_time(func, threshold, ...)
  threshold = threshold or 0.0001 -- Default threshold: 0.1 milliseconds
  local start_time = os.clock()
  local results = { func(...) }
  local elapsed_time = os.clock() - start_time
  if elapsed_time >= threshold then
    M.log_debug(string.format("Function executed in %.4f seconds", elapsed_time))
  end
  return unpack(results)
end

--- Logs a debug message to the log file.
-- @param message (string) The message to log.
function M.log_debug(message)
  if config.config.debug then
    M.log_to_file(message)
  end
end

--- Opens the log file and displays the last lines first.
-- @param num_lines (number) Number of lines to display from the end of the log file.
function M.show_latest_logs(num_lines)
  num_lines = num_lines or 20 -- Default: show the last 20 lines
  local log_file = config.config.log_file_path

  vim.loop.fs_open(log_file, "r", 438, function(open_err, fd)
    if open_err then
      vim.schedule(function()
        vim.notify("Failed to open log file: " .. log_file .. " - Error: " .. open_err, vim.log.levels.ERROR)
      end)
      return
    end

    vim.loop.fs_stat(log_file, function(stat_err, stat)
      if stat_err then
        vim.schedule(function()
          vim.notify("Failed to read log file stats: " .. stat_err, vim.log.levels.ERROR)
        end)
        return
      end

      local file_size = stat.size
      local buffer_size = math.min(file_size, 1024 * 10) -- Read up to 10KB from the end
      local offset = math.max(0, file_size - buffer_size)

      vim.loop.fs_read(fd, buffer_size, offset, function(read_err, data)
        vim.loop.fs_close(fd)

        if read_err then
          vim.schedule(function()
            vim.notify("Failed to read log file: " .. read_err, vim.log.levels.ERROR)
          end)
          return
        end

        local lines = {}
        for line in data:gmatch("[^\r\n]+") do
          table.insert(lines, line)
        end

        -- Reverse the lines to show the latest first
        local reversed_lines = {}
        for i = #lines, math.max(1, #lines - num_lines + 1), -1 do
          table.insert(reversed_lines, lines[i])
        end

        -- Use vim.schedule to safely open a new buffer
        vim.schedule(function()
          vim.cmd("vnew | setlocal buftype=nofile bufhidden=wipe nobuflisted")
          local bufnr = vim.api.nvim_get_current_buf()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, reversed_lines)
          vim.bo.filetype = "log"

          -- Set up temporary keymaps to close the buffer with 'q' or ESC
          vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":close<CR>", { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })

          vim.notify(
            "Showing last " .. num_lines .. " lines of the log file. Press 'q' or ESC to close.",
            vim.log.levels.INFO
          )
        end)
      end)
    end)
  end)
end
-- Create a user command to show the latest logs
vim.api.nvim_create_user_command("ShowLatestLogs", function(opts)
  local num_lines = tonumber(opts.args) or 500
  M.show_latest_logs(num_lines)
end, {
  nargs = "?",
  complete = function()
    return { "20" }
  end,
})

return M
