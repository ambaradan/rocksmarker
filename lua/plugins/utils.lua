-- lua/plugins/utils.lua

-- telescope.nvim settings
-- Load Telescope actions
local actions_ok, actions = pcall(require, "telescope.actions")
if not actions_ok then
  return
end

-- Configure Telescope
local telescope_ok, telescope = pcall(require, "telescope")
if not telescope_ok then
  return
end

telescope.setup({
  defaults = {
    prompt_prefix = "   ",
    selection_caret = " ",
    entry_prefix = " ",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
      width = 0.87,
      height = 0.80,
    },
  },
  mappings = {
    i = {
      ["<esc>"] = actions.close,
    },
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      sort_mru = true,
      previewer = false,
      hidden = true,
      theme = "dropdown",
    },
    command_history = { theme = "dropdown" },
    git_status = { theme = "ivy" },
    git_commits = { theme = "ivy" },
    oldfiles = { previewer = false, theme = "dropdown" },
  },
  extensions = {
    file_browser = {
      theme = "ivy",
      hide_parent_dir = true,
      hijack_netrw = true,
      mappings = {
        ["i"] = {},
        ["n"] = {},
      },
    },
    frecency = {
      show_scores = true,
      theme = "dropdown",
    },
    undo = {
      theme = "ivy",
    },
    ["ui-select"] = {
      theme = "dropdown",
      initial_mode = "normal",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          width = 0.5,
          height = 0.4,
          preview_width = 0.6,
        },
      },
    },
  },
})

-- Load Telescope extensions
local extensions = {
  "file_browser",
  "cmdline",
  "frecency",
  "ui-select",
  "fidget",
  "undo",
}

for _, ext in ipairs(extensions) do
  pcall(function()
    telescope.load_extension(ext)
  end)
end

-- persisted.nvim settings
local persisted_ok, persisted = pcall(require, "persisted")
if not persisted_ok then
  return
end

persisted.setup({
  autoload = false,
})

-- Enable Telescope support for persisted.nvim
pcall(function()
  require("telescope").load_extension("persisted")
end)

-- toggleterm.nvim settings
local toggleterm_ok, toggleterm = pcall(require, "toggleterm")
if not toggleterm_ok then
  return
end

toggleterm.setup({
  -- Basic configuration
  size = function(term)
    if term.direction == "horizontal" then
      return vim.o.lines * 0.4
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-t>]],
  hide_numbers = true,
  direction = "float",
  -- Additional basic settings
  start_in_insert = true,
  close_on_exit = true,
  shell = vim.o.shell,
  -- Float Terminal Settings
  float_opts = {
    border = "curved",
    width = function()
      return math.floor(vim.o.columns * 0.5) -- % of screen width
    end,
    height = function()
      return math.floor(vim.o.lines * 0.4) -- % of screen height
    end,
    winblend = 10, -- Transparency level
    row = function()
      return 2 -- Row to the top of the screen
    end,
    col = function()
      return vim.o.columns - math.floor(vim.o.columns * 0.4) - 3
    end,
  },
  -- Highlight configuration
  highlights = {
    Normal = {
      guibg = "Normal",
    },
    NormalFloat = {
      link = "@comment",
    },
    FloatBorder = {
      link = "FloatBorder",
    },
  },
})

-- neo-tree.nvim settings
local neo_tree_ok, neo_tree = pcall(require, "neo-tree")
if not neo_tree_ok then
  return
end

local function calculate_width_percentage(percentage)
  local screen_width = vim.o.columns
  return math.floor(screen_width * (percentage / 100))
end

neo_tree.setup({
  -- Close Neo-tree if it is the last window in the tab
  close_if_last_window = false,
  -- File system configuration
  filesystem = {
    bind_to_cwd = true, -- Open Neo-tree at the current working directory
    follow_current_file = {
      enabled = true, -- Update the tree when switching buffers
    },
    use_libuv_file_watcher = true, -- Use libuv for file watching (better performance)
    filtered_items = {
      visible = true, -- Show hidden files (dotfiles)
      hide_dotfiles = false,
      hide_gitignored = true,
      hide_by_name = {
        -- Files or directories to hide
        ".DS_Store",
        "thumbs.db",
      },
      never_show = {
        -- Files or directories that should never be shown
        ".git",
      },
    },
    window = {
      mappings = {
        -- Key mappings for the file system window
        ["l"] = "open",
        ["h"] = "close_node",
        ["<cr>"] = "open",
        ["o"] = "open",
        ["<esc>"] = "cancel",
      },
    },
  },
  -- Buffer explorer configuration
  buffers = {
    follow_current_file = {
      enabled = true, -- Update the tree when switching buffers
    },
    group_empty_dirs = true, -- Group empty directories together
  },
  -- Git status configuration
  git_status = {
    window = {
      position = "right", -- Position of the git status window
      mappings = {
        -- Key mappings for the git status window
        ["A"] = "git_add_all",
        ["gu"] = "git_unstage_file",
        ["ga"] = "git_add_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
      },
      symbols = {
        -- Symbols for different file states
        added = "✚", -- Added files
        modified = "", -- Modified files
        deleted = "✖", -- Deleted files
        renamed = "", -- Renamed files
        untracked = "", -- Untracked files
        ignored = "", -- Ignored files
        unstaged = "", -- Unstaged changes
        staged = "", -- Staged changes
        conflict = "", -- Conflict files
      },
    },
  },
  diagnostics = {
    symbols = {
      -- Symbols for diagnostic issues
      hint = "", -- Hint diagnostics
      info = "", -- Info diagnostics
      warn = "", -- Warning diagnostics
      error = "", -- Error diagnostics
    },
  },
  -- Default component configurations
  default_component_configs = {
    indent = {
      indent_size = 2, -- Indentation size
      padding = 0, -- Extra padding
    },
    icon = {
      folder_closed = "", -- Icon for closed folders
      folder_open = "", -- Icon for open folders
      folder_empty = "", -- Icon for empty folders
      default = "", -- Default file icon
    },
    modified = {
      symbol = "[+]", -- Symbol for modified files
    },
    name = {
      trailing_slash = true, -- Add trailing slash to directory names
    },
  },
  -- Window configuration
  window = {
    position = "left", -- Position: "left", "right", "top", "bottom"
    width = calculate_width_percentage(40), -- Width of the Neo-tree window
    mappings = {
      -- Global key mappings for Neo-tree
      ["<space>"] = "none",
      ["l"] = "open",
      ["h"] = "close_node",
      ["<cr>"] = "open",
      ["o"] = "open",
      ["<esc>"] = "cancel",
    },
  },
  -- Filesystem filters
  filesystem_filters = {
    exclude = {
      -- Files or directories to exclude
      ".git",
      "node_modules",
    },
  },
  -- Event handlers
  event_handlers = {
    {
      event = "file_opened",
      handler = function()
        -- Close Neo-tree after opening a file
        require("neo-tree.command").execute({ action = "close" })
      end,
    },
  },
})

-- neogit.nvim settings - git manager
local neogit_ok, neogit = pcall(require, "neogit")
if not neogit_ok then
  return
end

neogit.setup({
  kind = "tab",
  disable_builtin_notifications = true,
  graph_style = "unicode",
  integrations = {
    telescope = true,
    diffview = true,
  },
  status = {
    -- show_head_commit_hash = true,
    recent_commit_count = 20,
  },
  commit_view = {
    kind = "floating",
    verify_commit = vim.fn.executable("gpg") == 1,
  },
})

-- spectre.nvim settings - search and replace plugin
local spectre_ok, spectre = pcall(require, "spectre")
if not spectre_ok then
  return
end

spectre.setup({
  live_update = false, -- auto execute search again when you write to any file
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

-- Enable Telescope support
pcall(function()
  require("telescope").load_extension("yank_history")
end)

-- indent-blankline.nvim settings
local ibl_ok, ibl = pcall(require, "ibl")
if not ibl_ok then
  return
end

ibl.setup({
  indent = { highlight = "IblIndent", char = "│" },
  exclude = {
    filetypes = {
      "help",
      "terminal",
      "dashboard",
      "packer",
      "TelescopePrompt",
      "TelescopeResults",
      "",
    },
    buftypes = { "terminal", "nofile" },
  },
  scope = { enabled = false },
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
