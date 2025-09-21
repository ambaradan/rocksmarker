-- lua/utils/debug.lua
local M = {}

---@param message string The message to log to file
function M.log_to_file(message)
	local log_file = vim.fn.stdpath("data") .. "/rocksmarker_debug.log"
	local timestamped_message = os.date("%Y-%m-%d %H:%M:%S") .. " - " .. message .. "\n"

	-- Apre il file in modalità append
	vim.loop.fs_open(log_file, "a", 438, function(err, fd)
		if err then
			vim.notify("Failed to open log file: " .. log_file .. " - Error: " .. err, vim.log.levels.ERROR)
			return
		end

		-- Scrive il messaggio nel file
		vim.loop.fs_write(fd, timestamped_message, -1, function(err, bytes_written)
			if err then
				vim.notify("Failed to write to log file: " .. err, vim.log.levels.ERROR)
			end
			-- Chiude il file
			vim.loop.fs_close(fd)
		end)
	end)
end

-- Add root to package.path to import config.lua
package.path = package.path .. ";../?.lua"

-- Import config.lua safely
local config = require("config") or { config = { debug = false } }

--- Log a table in a readable format (useful for debugging complex structures)
---@param tbl table The table to log
---@param indent integer|nil The indentation level (default: 0)
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
end

--- Execute a function and log its execution time (useful for performance debugging)
---@param func function The function to execute
---@param ... any Arguments to pass to the function
---@return any ... The return values of the executed function
function M.debug_execution_time(func, ...)
	local start_time = os.clock()
	local results = { func(...) }
	local elapsed_time = os.clock() - start_time
	M.log_debug(string.format("Function executed in %.4f seconds", elapsed_time))
	return unpack(results)
end

--- Print a debug message to the Neovim command line
---@param message string The message to print
function M.log_debug(message)
	if config.config and config.config.debug then
		vim.cmd("echo '" .. message:gsub("'", "''") .. "'")
	end
end

return M
