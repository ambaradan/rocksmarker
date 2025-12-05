-- lua/plugins/lsp.lua

--- Get LSP capabilities with support for Markdown and other features.
---@return table The LSP client capabilities.
local function get_lsp_capabilities()
  -- Initialize with default client capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Try to extend capabilities with blink.cmp
  local blink_cmp_ok, blink_cmp = pcall(require, "blink.cmp")
  if blink_cmp_ok then
    ---@diagnostic disable-next-line: need-check-nil
    capabilities = blink_cmp.get_lsp_capabilities(capabilities)
  else
    vim.notify("blink.cmp not found. Using default capabilities.", vim.log.levels.WARN)
  end

  -- Ensure the structure exists
  capabilities.textDocument = capabilities.textDocument or {}
  capabilities.textDocument.completion = capabilities.textDocument.completion or {}
  capabilities.textDocument.completion.completionItem = capabilities.textDocument.completion.completionItem or {}

  -- Extend completion item capabilities with Markdown support
  local new_capabilities = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    },
  }

  -- Manually extend the table
  for key, value in pairs(new_capabilities) do
    capabilities.textDocument.completion.completionItem[key] = value
  end

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
local function setup_lsp_server(server_name, config)
  -- Check if the specified LSP server is available in lspconfig.
  if not lspconfig[server_name] then
    vim.notify("LSP server not found: " .. server_name, vim.log.levels.WARN)
    return
  end

  -- Set up the LSP server with the provided configuration.
  lspconfig[server_name].setup(vim.tbl_deep_extend("force", { capabilities = get_lsp_capabilities() }, config or {}))
end

-- Configure Taplo language server for TOML file support in Neovim.
setup_lsp_server("taplo", {
  -- Settings specific to Taplo LSP.
  settings = {
    -- Formatting configuration: enable or disable automatic formatting.
    format = {
      enable = true,
    },

    -- Completion configuration: control how code completion works.
    completion = {
      enable = true,
      -- Characters that trigger completion suggestions.
      triggerCharacters = { ".", '"', "'" },
    },

    -- Diagnostics configuration: control how errors and warnings are displayed.
    diagnostics = {
      enable = true,
      severity = "Error",
    },

    -- Schema support configuration: enable or disable JSON schema validation.
    schema = {
      enable = false,
    },
  },

  -- Specify the filetypes for which Taplo should be activated.
  filetypes = { "toml" },
})

-- Marksman provides advanced Markdown language features such as syntax checking,
-- formatting, and navigation.
setup_lsp_server("marksman", {
  -- The `get_lsp_capabilities()` function returns a table of capabilities that enhance
  -- the interaction between Neovim and the LSP server.
  capabilities = get_lsp_capabilities(),

  -- Specify the filetypes for which Marksman should be activated.
  filetypes = { "markdown", "md" },
})

-- Configure vale_ls for prose linting in Neovim.
setup_lsp_server("vale_ls", {
  -- Use extended client capabilities for full LSP feature support.
  capabilities = get_lsp_capabilities(),

  -- Specify the filetypes for which vale_ls should be activated.
  filetypes = { "markdown", "text", "tex", "rst" },

  -- Optional: Set the root directory pattern to look for '.vale.ini'
  -- root_dir = require('lspconfig.util').root_pattern('.vale.ini'),

  -- Enable single file support.
  single_file_support = true,

  -- Optional: Add any additional settings for vale_ls.
  settings = {
    -- If you have specific Vale settings, they can be added here.
  },
})

-- Configure Harper language server for grammar and style checking in Neovim.
-- Harper is a privacy-first, offline grammar checker for developers and writers.
setup_lsp_server("harper_ls", {
  settings = {
    -- All Harper-specific settings must be nested under the harper-ls key.
    ["harper-ls"] = {
      -- Linters configuration: enable or disable specific grammar and style checks.
      linters = {
        SpellCheck = true,
        SpelledNumbers = false,
        AnA = true,
        SentenceCapitalization = true,
        UnclosedQuotes = true,
        WrongQuotes = false,
        LongSentences = true,
        RepeatedWords = true,
        Spaces = true,
        Matcher = true,
        CorrectNumberSuffix = true,
      },

      -- Code actions configuration: control how code actions are displayed.
      codeActions = {
        ForceStable = false,
      },

      -- Markdown-specific settings: control how Harper handles Markdown files.
      markdown = {
        IgnoreLinkTitle = false,
        IgnoreCodeBlocks = true,
        IgnoreInlineCode = true,
        CheckLists = true,
        CheckHeadings = true,
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

---@diagnostic disable-next-line: need-check-nil
mason.setup({}) -- Initialize Mason with default settings.

-- Setup Mason-LSPConfig to bridge Mason and nvim-lspconfig.
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then
  vim.notify("mason-lspconfig not installed.", vim.log.levels.ERROR)
  return
end

---@diagnostic disable-next-line: need-check-nil
mason_lspconfig.setup({
  -- List of LSP servers to automatically install.
  ensure_installed = {
    "emmylua_ls",
    "html",
    "cssls",
    "marksman",
    "harper_ls",
    "yamlls",
    "bashls",
    "taplo",
    "jsonls",
    "vimls",
    "vale_ls",
  },
  -- Handler to automatically set up each installed LSP server.
  handlers = {
    function(server_name)
      setup_lsp_server(server_name, {})
    end,
  },
})

-- Mason tool installer for additional formatting, linting, and utility tools.
local mason_tool_installer_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
if not mason_tool_installer_ok then
  vim.notify("mason-tool-installer not installed.", vim.log.levels.ERROR)
  return
end

---@diagnostic disable-next-line: need-check-nil
mason_tool_installer.setup({
  -- List of tools to automatically install for formatting, linting, and validation.
  ensure_installed = {
    "markdownlint",
    "vale",
    "emmylua-codeformat",
    "shfmt",
    "yamlfmt",
    "shellcheck",
    "prettier",
    "yamllint",
    "jsonlint",
    "vint",
  },
  auto_update = true,
  run_on_start = true,
})

-- Configure blink.cmp for autocompletion in Neovim.
local blink_cmp_ok, blink_cmp = pcall(require, "blink.cmp")
if not blink_cmp_ok then
  vim.notify("blink.cmp not installed.", vim.log.levels.ERROR)
  return
end

---@diagnostic disable-next-line: need-check-nil
blink_cmp.setup({
  -- Keymap configuration for completion behavior.
  keymap = {
    preset = "super-tab",
    ["<ESC>"] = { "cancel", "fallback" },
  },
  -- Command-line mode completion settings.
  cmdline = {
    keymap = {
      preset = "default",
    },
  },
  -- Fuzzy matching settings for completion results.
  fuzzy = {
    implementation = "lua",
  },
})
