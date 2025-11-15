-- lua/plugins/utils.lua

local snacks_ok, snacks = pcall(require, "snacks")
if not snacks_ok then
  return
end

snacks.setup({
  indent = {
    enabled = true,
  },
  explorer = {
    enabled = true,
  },
  input = {
    enabled = true,
  },
  lazygit = {
    enabled = true,
    theme = {
      activeBorderColor = { fg = "Attribute" },
    },
    win = {
      style = "lazygit",
    },
  },
  picker = {
    ui_select = true,
  },
  zen = {
    center = true,
    win = {
      style = "zen",
      width = 0.9,
      height = 0,
    },
    toggles = {
      dim = false,
      git_signs = true,
      mini_diff_signs = false,
    },
    show = {
      statusline = false,
      tabline = false,
    },
    zoom = {
      toggles = {},
      center = false,
      show = {
        statusline = false,
        tabline = false,
      },
      win = {
        backdrop = false,
        width = 0,
      },
    },
  },
  notifier = {
    enabled = true,
    timeout = 3000,
    style = "minimal",
    margin = { top = 1, right = 1, bottom = 0 },
  },
  defaults = {
    files = {
      finder = "files",
      format = "file",
      show_empty = true,
      hidden = true,
      ignored = false,
      follow = false,
      supports_live = true,
    },
  },
})

-- rainbow-delimiters setting
local rainbow_delimiters_ok, rainbow_delimiters = pcall(require, "rainbow-delimiters.setup")
if not rainbow_delimiters_ok then
  return
end

rainbow_delimiters.setup({
  strategy = {
    [""] = require("rainbow-delimiters").strategy["global"],
    vim = require("rainbow-delimiters").strategy["local"],
  },
  query = {
    [""] = "rainbow-delimiters",
    lua = "rainbow-blocks",
  },
  highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterYellow",
    "RainbowDelimiterBlue",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
    "RainbowDelimiterViolet",
    "RainbowDelimiterCyan",
  },
})

-- nvim-highlight-colors.nvim settings {{{{
local highlight_colors_ok, highlight_colors = pcall(require, "nvim-highlight-colors")
if not highlight_colors_ok then
  return
end

highlight_colors.setup({
  render = "virtual",
})
