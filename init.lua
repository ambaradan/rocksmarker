-- init.lua
local debug_utils = require("utils.debug")

-- Configuration for LuaRocks integration in Neovim
debug_utils.log_debug("Starting LuaRocks configuration...")

local rocks_config = {
	rocks_path = vim.env.HOME .. "/.local/share/nvim/rocks",
}

-- Log the LuaRocks path
debug_utils.log_debug("LuaRocks path set to: " .. rocks_config.rocks_path)

-- Set global variable for LuaRocks configuration
vim.g.rocks_nvim = rocks_config
debug_utils.log_debug("Global variable 'rocks_nvim' set successfully.")

-- Configure Lua package.path to include LuaRocks paths
local luarocks_path = {
	vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
	vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
}
package.path = package.path .. ";" .. table.concat(luarocks_path, ";")
debug_utils.log_debug("Updated Lua package.path with LuaRocks paths.")
debug_utils.log_table(luarocks_path, 0)

-- Configure Lua package.cpath to include LuaRocks compiled libraries
local luarocks_cpath = {
	vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
	vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
}
package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")
debug_utils.log_debug("Updated Lua package.cpath with LuaRocks compiled library paths.")
debug_utils.log_table(luarocks_cpath, 0)

-- Add LuaRocks to Neovim's runtimepath
vim.opt.runtimepath:append(vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", "*", "*"))
debug_utils.log_debug("Added LuaRocks to Neovim's runtimepath.")

-- Load user-defined configurations
debug_utils.log_debug("Loading user-defined configurations...")

debug_utils.debug_execution_time(function()
	require("options")
end)
debug_utils.log_debug("Loaded 'options' module.")

debug_utils.debug_execution_time(function()
	require("commands")
end)
debug_utils.log_debug("Loaded 'commands' module.")

debug_utils.debug_execution_time(function()
	require("mappings")
end)
debug_utils.log_debug("Loaded 'mappings' module.")

debug_utils.log_debug("Neovim initialization completed successfully.")
