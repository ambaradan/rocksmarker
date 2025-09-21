-- lua/utils/debug.lua
-- Debug and logging utilities for Neovim.
-- This module provides functions for logging messages, tables, and execution times.

local M = {}

-- Import configuration
local config = require("config")
	or {
		config = {
			debug = false,
			log_file_path = vim.fn.stdpath("data") .. "/rocksmarker_debug.log",
		},
	}

--- Writes a message to a logfile with a timestamp.
-- @param message (string) The message to log.
function M.log_to_file(message)
	local log_file = config.config.log_file_path
	local timestamped_message = os.date("%Y-%m-%d %H:%M:%S") .. " - " .. message .. "\n"

	-- Open the file in append mode
	vim.loop.fs_open(log_file, "a", 438, function(err, fd)
		if err then
			vim.notify("Failed to open log file: " .. log_file .. " - Error: " .. err, vim.log.levels.ERROR)
			return
		end

		-- Write the message to the file
		vim.loop.fs_write(fd, timestamped_message, -1, function(err)
			if err then
				vim.notify("Failed to write to log file: " .. err, vim.log.levels.ERROR)
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

--- Executes a function and logs its execution time (useful for performance debugging).
-- @param func (function) The function to execute.
-- @param ... (any) Arguments to pass to the function.
-- @return (any) The return values of the executed function.
function M.debug_execution_time(func, ...)
	local start_time = os.clock()
	local results = { func(...) }
	local elapsed_time = os.clock() - start_time

	M.log_debug(string.format("Function executed in %.4f seconds", elapsed_time))
	return unpack(results)
end

--- Logs a debug message to the log file.
-- @param message (string) The message to log.
function M.log_debug(message)
	if config.config.debug then
		M.log_to_file(message)
	end
end

return M
