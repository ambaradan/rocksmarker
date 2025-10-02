-- lua/config.lua
local M = {}

--- Main configuration table.
-- @field debug (boolean) Enable or disable debug messages.
-- @field log_file_path (string) Path to the debug log file.
M.config = {
	debug = false, -- Enable or disable debug messages
	log_file_path = vim.fn.stdpath("data") .. "/rocksmarker_debug.log", -- Path to the log file
}

return M
