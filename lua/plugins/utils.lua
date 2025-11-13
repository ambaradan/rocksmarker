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

-- persisted.nvim settings
local persisted_ok, persisted = pcall(require, "persisted")
if not persisted_ok then
  return
end

persisted.setup({
  autoload = false,
})

-- yanky.nvim settings
local yanky_ok, yanky = pcall(require, "yanky")
if not yanky_ok then
  return
end

yanky.setup({
  highlight = {
    on_put = true,
    on_yank = true,
  },
  ring = {
    history_length = 200,
    storage = "shada",
    sync_with_numbered_registers = true,
    cancel_event = "update",
    ignore_registers = { "_" },
    update_register_on_cycle = false,
  },
  system_clipboard = {
    sync_with_ring = true,
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

-- nvim-autopairs.nvim settings
local autopairs_ok, autopairs = pcall(require, "nvim-autopairs")
if not autopairs_ok then
  return
end

autopairs.setup({
  disable_filetype = { "vim" },
})
-- }}}

-- nvim-highlight-colors.nvim settings {{{{
local highlight_colors_ok, highlight_colors = pcall(require, "nvim-highlight-colors")
if not highlight_colors_ok then
  return
end

highlight_colors.setup({
  render = "virtual",
})
