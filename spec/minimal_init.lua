-- spec/minimal_init.lua

-- Set the runtime path for Neovim
vim.opt.runtimepath:prepend(vim.fn.getcwd())

-- Load plenary.nvim for testing
local plenary_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/plenary.nvim"
if vim.fn.empty(vim.fn.glob(plenary_path)) > 0 then
  vim.notify("plenary.nvim not found. Cloning into data directory...")
  vim.fn.system({
    "git",
    "clone",
    "--depth=1",
    "https://github.com/nvim-lua/plenary.nvim",
    plenary_path,
  })
end
vim.opt.runtimepath:prepend(plenary_path)

-- Load plenary
require("plenary")
require("plenary.busted")

-- Load helper utilities for tests
require("spec.helper")
