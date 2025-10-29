-- Set the runtimepath to include the plugin being tested
vim.opt.runtimepath:prepend(vim.fn.getcwd())

-- Load plenary.nvim (required for testing)
vim.cmd([[runtime plugin/plenary.vim]])

-- Temporary setup for rocks.nvim configuration
local function setup_rocks_nvim()
  -- Specifies where to install/use rocks.nvim
  local install_location = vim.fs.joinpath(vim.fn.stdpath("data"), "rocks")

  -- Set up configuration options related to rocks.nvim
  local rocks_config = {
    rocks_path = vim.fs.normalize(install_location),
  }
  vim.g.rocks_nvim = rocks_config

  -- Configure the Lua package path to find rocks.nvim plugin code
  local luarocks_path = {
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
  }
  package.path = package.path .. ";" .. table.concat(luarocks_path, ";")

  -- Configure the C package path for Lua (e.g., for tree-sitter parsers)
  local luarocks_cpath = {
    vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
    vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
  }
  package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")

  -- Add rocks.nvim to the runtimepath
  vim.opt.runtimepath:append(
    vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", "rocks.nvim", "*")
  )

  -- Install rocks.nvim if it is not already installed
  if not pcall(require, "rocks") then
    local rocks_location = vim.fs.joinpath(vim.fn.stdpath("cache"), "rocks.nvim")
    if not vim.uv.fs_stat(rocks_location) then
      -- Clone rocks.nvim repository
      local url = "https://github.com/lumen-oss/rocks.nvim"
      vim.fn.system({ "git", "clone", "--filter=blob:none", url, rocks_location })
      -- Ensure the clone was successful
      assert(vim.v.shell_error == 0, "Failed to clone rocks.nvim. Check your connection and try again!")
    end
    -- Source the bootstrapping script if the clone was successful
    vim.cmd.source(vim.fs.joinpath(rocks_location, "bootstrap.lua"))
    -- Clean up the cloned repository
    vim.fn.delete(rocks_location, "rf")
  end
end

-- Execute the rocks.nvim setup
setup_rocks_nvim()

-- Load additional plugin configurations
require("options")
require("commands")
require("mappings")
