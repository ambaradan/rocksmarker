-- lua/plugins/lsp.lua

-- Create an autocommand group for LSP attachments.
-- This group will be cleared on creation to avoid duplicate commands.
vim.api.nvim_create_augroup("LspAttachAll", { clear = true })

-- Set up the autocommand for the LspAttach event.
-- This event is triggered when an LSP client attaches to a buffer.
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttachAll",
  callback = function(args)
    -- Retrieve the LSP client and buffer number from the event arguments.
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    -- Exit early if the client is not valid.
    if not client then
      return
    end

    -- Helper function to set buffer-local keymaps.
    -- @param keys: The key sequence to map.
    -- @param func: The function to execute when the keys are pressed.
    -- @param desc: Description of the keymap for documentation purposes.
    local function map(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
    end

    -- Set up basic LSP keymaps for navigation and actions.
    map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    -- Check if Telescope is available for enhanced LSP features.
    -- Telescope provides a more interactive way to view references, implementations, and symbols.
    local telescope_ok, telescope = pcall(require, "telescope.builtin")
    if telescope_ok then
      map("gr", function()
        telescope.lsp_references({ theme = "ivy" })
      end, "[G]oto [R]eferences")
      map("gI", function()
        telescope.lsp_implementations({ theme = "ivy" })
      end, "[G]oto [I]mplementation")
      map("<leader>D", function()
        telescope.lsp_type_definitions({ theme = "dropdown" })
      end, "Type [D]efinition")
      map("<leader>ds", function()
        telescope.lsp_document_symbols({ theme = "dropdown" })
      end, "[D]ocument [S]ymbols")
      map("<leader>ws", function()
        telescope.lsp_dynamic_workspace_symbols({ theme = "dropdown" })
      end, "[W]orkspace [S]ymbols")
    else
      -- Notify the user if Telescope is not installed.
      vim.notify("Telescope not installed. Some LSP features will be limited.", vim.log.levels.WARN)
    end

    -- Enable document highlighting if the LSP client supports it.
    -- This highlights references to the symbol under the cursor.
    if client.server_capabilities.documentHighlightProvider then
      local hl_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

      -- Highlight references on cursor hold.
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = hl_group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })

      -- Clear highlights when the cursor moves.
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = hl_group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })

      -- Clean up highlights and autocommands when the LSP detaches.
      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
        callback = function(detach_event)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = detach_event.buf })
        end,
      })
    end

    -- Enable inlay hints if the LSP client supports it.
    -- Inlay hints provide additional context directly in the code.
    if client.server_capabilities.inlayHintProvider then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}), { bufnr = bufnr })
      end, "[T]oggle Inlay [H]ints")
    end
  end,
})

--- Get LSP capabilities with support for Markdown and other features.
---@return table The LSP client capabilities.
local function get_lsp_capabilities()
  -- Initialize with default client capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Try to extend capabilities with blink.cmp
  local blink_cmp_ok, blink_cmp = pcall(require, "blink.cmp")
  if blink_cmp_ok then
    capabilities = blink_cmp.get_lsp_capabilities(capabilities)
  else
    vim.notify("blink.cmp not found. Using default capabilities.", vim.log.levels.WARN)
  end

  -- Ensure the structure exists
  capabilities.textDocument = capabilities.textDocument or {}
  capabilities.textDocument.completion = capabilities.textDocument.completion or {}
  capabilities.textDocument.completion.completionItem = capabilities.textDocument.completion.completionItem or {}

  -- Extend completion item capabilities with Markdown support
  capabilities.textDocument.completion.completionItem =
    vim.tbl_deep_extend("force", capabilities.textDocument.completion.completionItem, {
      documentationFormat = { "markdown", "plaintext" }, -- Enable Markdown and plaintext documentation
      snippetSupport = true, -- Enable snippet support
      preselectSupport = true, -- Enable preselect support
      insertReplaceSupport = true, -- Enable insert/replace support
      labelDetailsSupport = true, -- Enable label details support
      deprecatedSupport = true, -- Enable deprecated items support
      commitCharactersSupport = true, -- Enable commit characters support
      tagSupport = { valueSet = { 1 } }, -- Enable tag support
      resolveSupport = {
        properties = {
          "documentation", -- Enable documentation resolution
          "detail", -- Enable detail resolution
          "additionalTextEdits", -- Enable additional text edits
        },
      },
    })

  return capabilities
end

-- Setup language servers using lspconfig.
-- This module is essential for configuring and managing LSP servers in Neovim.
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
  -- Notify the user if lspconfig is not installed.
  vim.notify("lspconfig not installed.", vim.log.levels.ERROR)
  return
end

-- Helper function to setup an LSP server with error handling.
-- This function ensures that the server is available and applies the provided configuration.
-- @param server_name: The name of the LSP server to set up (e.g., "tsserver", "pyright").
-- @param config: Optional configuration table for the LSP server.
--                If not provided, an empty table is used.
local function setup_lsp_server(server_name, config)
  -- Check if the specified LSP server is available in lspconfig.
  if not lspconfig[server_name] then
    vim.notify("LSP server not found: " .. server_name, vim.log.levels.WARN)
    return
  end

  -- Set up the LSP server with the provided configuration.
  -- `vim.tbl_deep_extend` merges the default capabilities with the user-provided config.
  -- The "force" option ensures that nested tables are also merged.
  lspconfig[server_name].setup(vim.tbl_deep_extend(
    "force",
    { capabilities = get_lsp_capabilities() }, -- Default capabilities
    config or {} -- User-provided configuration
  ))
end

-- Configure the Lua language server (`lua_ls`).
-- This setup is specific to Lua and includes settings for runtime, diagnostics, workspace, and formatting.
setup_lsp_server("lua_ls", {
  settings = {
    Lua = {
      -- Runtime configuration for Lua.
      -- Specifies the Lua version and the runtime file paths.
      runtime = {
        version = "LuaJIT", -- Use LuaJIT as the runtime environment.
        path = vim.split(package.path, ";"), -- Set the Lua path to include all paths from `package.path`.
      },

      -- Configuration for code completion.
      completion = {
        callSnippet = "Replace", -- Replace the default snippet behavior with the completed text.
        displayContext = 5, -- Show up to 5 context lines in completion documentation.
      },

      -- Diagnostics settings to control warnings and errors.
      diagnostics = {
        -- Disable specific diagnostic warnings.
        disable = {
          "lowercase-global", -- Ignore warnings about lowercase global variables.
          "undefined-field", -- Ignore warnings about undefined fields.
        },
      },

      -- Workspace settings to manage library paths and file handling.
      workspace = {
        -- Specify additional Lua libraries to include in the workspace.
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true, -- Include Neovim's built-in Lua libraries.
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true, -- Include Neovim's LSP-specific Lua libraries.
        },
        -- Directories to ignore when indexing the workspace.
        ignoreDir = { ".git", "node_modules" },
        -- Maximum number of files to preload for faster indexing.
        maxPreload = 2000,
        -- Maximum file size (in KB) for preloading.
        preloadFileSize = 500,
      },

      -- Formatting settings.
      format = {
        enable = false, -- Disable automatic formatting by the LSP server.
      },

      -- Telemetry settings.
      telemetry = {
        enable = false, -- Disable telemetry to avoid sending usage data.
      },

      -- Inline hint settings for better code readability.
      hint = {
        enable = true, -- Enable inline hints.
        arrayIndex = "Enable", -- Show hints for array indices.
        await = true, -- Show hints for `await` expressions.
        paramName = "All", -- Show hints for all parameter names.
        paramType = true, -- Show hints for parameter types.
        semicolon = "SameLine", -- Place semicolons on the same line as the code.
        setType = true, -- Show hints for variable types in assignments.
      },
    },
  },
})

-- Configure Taplo language server for TOML file support in Neovim.
-- Taplo provides advanced features like formatting, completion, and diagnostics for TOML files.
setup_lsp_server("taplo", {
  -- Settings specific to Taplo LSP.
  settings = {
    -- Formatting configuration: enable or disable automatic formatting.
    format = {
      enable = true, -- Enable automatic formatting of TOML files.
    },

    -- Completion configuration: control how code completion works.
    completion = {
      enable = true, -- Enable code completion for TOML files.
      -- Characters that trigger completion suggestions.
      triggerCharacters = { ".", '"', "'" },
    },

    -- Diagnostics configuration: control how errors and warnings are displayed.
    diagnostics = {
      enable = true, -- Enable diagnostics for TOML files.
      severity = "Error", -- Set the default severity level for diagnostics to "Error".
    },

    -- Schema support configuration: enable or disable JSON schema validation.
    schema = {
      enable = false, -- Disable JSON schema validation for TOML files.
    },
  },

  -- Specify the filetypes for which Taplo should be activated.
  -- In this case, Taplo is only enabled for TOML files.
  filetypes = { "toml" },
})

-- Marksman provides advanced Markdown language features such as syntax checking,
-- formatting, and navigation.
setup_lsp_server("marksman", {
  -- The `get_lsp_capabilities()` function returns a table of capabilities that enhance
  -- the interaction between Neovim and the LSP server.
  capabilities = get_lsp_capabilities(),

  -- Specify the filetypes for which Marksman should be activated.
  -- Marksman is enabled for both "markdown" and "md" filetypes to cover all common
  -- Markdown file extensions.
  filetypes = { "markdown", "md" },
})

-- Configure vale_ls for prose linting in Neovim.
-- Vale is a syntax-aware linter for prose (Markdown, text, LaTeX, etc.).
setup_lsp_server("vale_ls", {
  -- Use extended client capabilities for full LSP feature support.
  capabilities = get_lsp_capabilities(),

  -- Specify the filetypes for which vale_ls should be activated.
  filetypes = { "markdown", "text", "tex", "rst" },

  -- Optional: Set the root directory pattern to look for .vale.ini.
  -- root_dir = require('lspconfig.util').root_pattern('.vale.ini'),

  -- Enable single file support.
  single_file_support = true,

  -- Optional: Add any additional settings for vale_ls.
  settings = {
    -- If you have specific Vale settings, they can be added here.
    -- Vale will automatically look for a .vale.ini file in the project root.
  },
})

-- Configure Harper language server for grammar and style checking in Neovim.
-- Harper is a privacy-first, offline grammar checker for developers and writers.
setup_lsp_server("harper_ls", {
  settings = {
    -- All Harper-specific settings must be nested under the "harper-ls" key.
    ["harper-ls"] = {
      -- Linters configuration: enable or disable specific grammar and style checks.
      linters = {
        SpellCheck = true, -- Enable spell checking.
        SpelledNumbers = false, -- Disable warnings for spelled-out numbers.
        AnA = true, -- Check for correct usage of "a" and "an".
        SentenceCapitalization = true, -- Ensure sentences start with a capital letter.
        UnclosedQuotes = true, -- Detect unclosed quotes.
        WrongQuotes = false, -- Disable warnings for incorrect quote usage.
        LongSentences = true, -- Warn about long sentences.
        RepeatedWords = true, -- Detect repeated words.
        Spaces = true, -- Check for spacing issues.
        Matcher = true, -- Enable pattern matching for style issues.
        CorrectNumberSuffix = true, -- Correct number suffixes (e.g., "1st", "2nd").
      },

      -- Code actions configuration: control how code actions are displayed.
      codeActions = {
        ForceStable = false, -- Do not force stable code actions.
      },

      -- Markdown-specific settings: control how Harper handles Markdown files.
      markdown = {
        IgnoreLinkTitle = false, -- Do not ignore link titles in Markdown.
        IgnoreCodeBlocks = true, -- Ignore code blocks in Markdown.
        IgnoreInlineCode = true, -- Ignore inline code in Markdown.
        CheckLists = true, -- Check lists in Markdown.
        CheckHeadings = true, -- Check headings in Markdown.
      },

      -- Set the severity level for diagnostics.
      -- Options: "error", "warning", "information", "hint"
      diagnosticSeverity = "hint",

      -- Isolate English language checks to avoid false positives in mixed-language documents.
      isolateEnglish = true,
    },
  },
})

-- Setup Mason for managing LSP servers and related tools.
local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
  vim.notify("mason.nvim not installed.", vim.log.levels.ERROR)
  return
end
mason.setup({}) -- Initialize Mason with default settings.

-- Setup Mason-LSPConfig to bridge Mason and nvim-lspconfig.
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then
  vim.notify("mason-lspconfig not installed.", vim.log.levels.ERROR)
  return
end
mason_lspconfig.setup({
  -- List of LSP servers to automatically install.
  ensure_installed = {
    "lua_ls", -- Lua language server
    "html", -- HTML language server
    "cssls", -- CSS language server
    "marksman", -- Markdown language server
    "harper_ls", -- Grammar and style checker for prose
    "yamlls", -- YAML language server
    "bashls", -- Bash language server
    "taplo", -- TOML language server
    "jsonls", -- JSON language server
    "vimls", -- Vimscript language server
    "vale_ls", -- Prose linter for Markdown and text
  },
  -- Handler to automatically set up each installed LSP server.
  handlers = {
    function(server_name)
      setup_lsp_server(server_name, {}) -- Use the custom setup function for each server
    end,
  },
})

-- Mason tool installer for additional formatting, linting, and utility tools.
local mason_tool_installer_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
if not mason_tool_installer_ok then
  vim.notify("mason-tool-installer not installed.", vim.log.levels.ERROR)
  return
end
mason_tool_installer.setup({
  -- List of tools to automatically install for formatting, linting, and validation.
  ensure_installed = {
    "markdownlint", -- Lint Markdown files
    "vale", -- Prose linter for Markdown and text
    "stylua", -- Lua code formatter
    "shfmt", -- Shell script formatter
    "yamlfmt", -- YAML formatter
    "shellcheck", -- Shell script static analysis
    "prettier", -- Code formatter for multiple languages
    "yamllint", -- YAML linter
    "jsonlint", -- JSON linter
    "vint", -- Vimscript linter
  },
  auto_update = true, -- Automatically update installed tools
  run_on_start = true, -- Install tools on Neovim startup
})

-- Configure blink.cmp for autocompletion in Neovim.
local blink_cmp_ok, blink_cmp = pcall(require, "blink.cmp")
if not blink_cmp_ok then
  vim.notify("blink.cmp not installed.", vim.log.levels.ERROR)
  return
end
blink_cmp.setup({
  -- Keymap configuration for completion behavior.
  keymap = {
    preset = "super-tab", -- Use Tab/Shift-Tab for navigation and confirmation
    ["<ESC>"] = { "cancel", "fallback" }, -- Cancel completion or fallback to default behavior
  },
  -- Command-line mode completion settings.
  cmdline = {
    keymap = {
      preset = "default", -- Use default keymaps for command-line mode
    },
  },
  -- Fuzzy matching settings for completion results.
  fuzzy = {
    implementation = "lua", -- Use Lua-based fuzzy matching for performance
  },
})

-- Load utility function to toggle Harper LSP for grammar and style checking.
local success, _ = pcall(require, "utils.lsp_toggle")
if not success then
  vim.notify("Failed to load utils.lsp_toggle", vim.log.levels.WARN)
end
