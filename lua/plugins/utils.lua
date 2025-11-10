-- lua/plugins/utils.lua

local snacks_ok, snacks = pcall(require, "snacks")
if not snacks_ok then
  return
end

snacks.setup({
  picker = {
    select = {
      enable = true,
      layout = {
        preset = "bottom",
      },
    },
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
  defaults = {
    opts = {
      indent = { enabled = true },
      explorer = { enabled = true },
      input = { enabled = true },
      lazygit = { enabled = true },
    },
    -- Default configurations for pickers
    files = {
      finder = "files",
      format = "file",
      show_empty = true,
      hidden = true,
      ignored = false,
      follow = false,
      supports_live = true,
    },
    explorer = {
      finder = "explorer",
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

-- neo-tree.nvim settings
-- local neo_tree_ok, neo_tree = pcall(require, "neo-tree")
-- if not neo_tree_ok then
--   return
-- end
--
-- local function calculate_width_percentage(percentage)
--   local screen_width = vim.o.columns
--   return math.floor(screen_width * (percentage / 100))
-- end
--
-- neo_tree.setup({
--   -- Close Neo-tree if it is the last window in the tab
--   close_if_last_window = false,
--   -- File system configuration
--   filesystem = {
--     -- Open Neo-tree at the current working directory
--     bind_to_cwd = true,
--     follow_current_file = {
--       enabled = true, -- Update the tree when switching buffers
--     },
--     -- Use libuv for file watching (better performance)
--     use_libuv_file_watcher = true,
--     filtered_items = {
--       visible = true, -- Show hidden files (dotfiles)
--       hide_dotfiles = false,
--       hide_gitignored = true,
--       hide_by_name = {
--         -- Files or directories to hide
--         ".DS_Store",
--         "thumbs.db",
--       },
--       never_show = {
--         -- Files or directories that should never be shown
--         ".git",
--       },
--     },
--     window = {
--       mappings = {
--         -- Key mappings for the filesystem window
--         ["l"] = "open",
--         ["h"] = "close_node",
--         ["<cr>"] = "open",
--         ["o"] = "open",
--         ["<esc>"] = "cancel",
--       },
--     },
--   },
--   -- Buffer explorer configuration
--   buffers = {
--     follow_current_file = {
--       enabled = true, -- Update the tree when switching buffers
--     },
--     group_empty_dirs = true, -- Group empty directories together
--   },
--   -- Git status configuration
--   git_status = {
--     window = {
--       position = "right", -- Position of the git status window
--       mappings = {
--         -- Key mappings for the git status window
--         ["A"] = "git_add_all",
--         ["gu"] = "git_unstage_file",
--         ["ga"] = "git_add_file",
--         ["gr"] = "git_revert_file",
--         ["gc"] = "git_commit",
--         ["gp"] = "git_push",
--         ["gg"] = "git_commit_and_push",
--       },
--       symbols = {
--         -- Symbols for different file states
--         added = "✚", -- Added files
--         modified = "", -- Modified files
--         deleted = "✖", -- Deleted files
--         renamed = "", -- Renamed files
--         untracked = "", -- Untracked files
--         ignored = "", -- Ignored files
--         unstaged = "", -- Unstaged changes
--         staged = "", -- Staged changes
--         conflict = "", -- Conflict files
--       },
--     },
--   },
--   diagnostics = {
--     symbols = {
--       -- Symbols for diagnostic issues
--       hint = "", -- Hint diagnostics
--       info = "", -- Info diagnostics
--       warn = "", -- Warning diagnostics
--       error = "", -- Error diagnostics
--     },
--   },
--   -- Default component configurations
--   default_component_configs = {
--     indent = {
--       indent_size = 2, -- Indentation size
--       padding = 0, -- Extra padding
--     },
--     icon = {
--       folder_closed = "", -- Icon for closed folders
--       folder_open = "", -- Icon for open folders
--       folder_empty = "", -- Icon for empty folders
--       default = "", -- Default file icon
--     },
--     modified = {
--       symbol = "[+]", -- Symbol for modified files
--     },
--     name = {
--       trailing_slash = true, -- Add trailing slash to directory names
--     },
--   },
--   -- Window configuration
--   window = {
--     position = "left", -- Position: "left", "right", "top", "bottom"
--     width = calculate_width_percentage(40), -- Width of the Neo-tree window
--     mappings = {
--       -- Global key mappings for Neo-tree
--       ["<space>"] = "none",
--       ["l"] = "open",
--       ["h"] = "close_node",
--       ["<cr>"] = "open",
--       ["o"] = "open",
--       ["<esc>"] = "cancel",
--     },
--   },
--   -- Filesystem filters
--   filesystem_filters = {
--     exclude = {
--       -- Files or directories to exclude
--       ".git",
--       "node_modules",
--     },
--   },
--   -- Event handlers
--   event_handlers = {
--     {
--       event = "file_opened",
--       handler = function()
--         -- Close Neo-tree after opening a file
--         require("neo-tree.command").execute({ action = "close" })
--       end,
--     },
--   },
-- })

-- neogit.nvim settings - git manager
local neogit_ok, neogit = pcall(require, "neogit")
if not neogit_ok then
  return
end

neogit.setup({
  kind = "tab",
  disable_builtin_notifications = true,
  graph_style = "unicode",
  status = {
    -- show_head_commit_hash = true,
    recent_commit_count = 20,
  },
  commit_view = {
    kind = "floating",
    verify_commit = vim.fn.executable("gpg") == 1,
  },
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
  disable_filetype = { "TelescopePrompt", "vim" },
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
